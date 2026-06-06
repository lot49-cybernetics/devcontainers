# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A collection of Lot49's base [devcontainer](https://containers.dev) images, published to `ghcr.io/lot49-cybernetics/*`. There is no application code — the "source" is a set of `devcontainer.json` files plus a handful of custom devcontainer Features (install scripts). Images are pre-built and pushed by CI; downstream Lot49 projects consume them by referencing the published image.

## Image inheritance chain

The five images stack on top of one another, each referencing the previous one's published GHCR image (not rebuilding it):

```
mcr.microsoft.com/devcontainers/base:noble   (Ubuntu Noble, external)
  └─ lot49-base                  pre-commit, linting, security/SBOM tooling
       └─ lot49-base-deploy      CI/CD, Kubernetes, IaC, secrets tooling
            ├─ lot49-base-java   Java toolchain
            └─ lot49-base-cpp    C/C++ toolchain
                 └─ lot49-base-polyglot   C/C++, Go, Python, TS, Rust, Zig, Bazel, WASM, Protobuf, LaTeX
```

This inheritance is expressed two ways and **both must stay consistent**:

1. **`image` / `build` field** in each `images/<name>/.devcontainer/devcontainer.json` points at the parent's GHCR tag (e.g. `lot49-base-cpp` uses `"image": "ghcr.io/lot49-cybernetics/lot49-base-deploy:noble"`). `lot49-base-polyglot` is the exception — it builds from a `Dockerfile` (`FROM ghcr.io/lot49-cybernetics/lot49-base-cpp:noble`) because it needs a `RUN` step (deadsnakes PPA for Python 3.14).
2. **`needs:` ordering** in `.github/workflows/ci.yml`. Each image can only build after its parent's manifest is published. Changing the inheritance chain means updating both the `image` field *and* the corresponding `needs:` dependency in CI.

## How an image is composed

Each image is a `devcontainer.json` whose `features` map pulls in published devcontainer Features. Tools generally come from existing Features (`ghcr.io/devcontainers/...`, `ghcr.io/devcontainers-extra/...`) or, for plain Ubuntu packages, the `apt-packages` feature with a `packages` array. Pin versions where the upstream feature supports it.

### Custom Features (local)

When no upstream feature exists, this repo defines its own under `images/<name>/.devcontainer/<feature>/`, referenced with a relative path (`"./buildifier": {...}`). Each is a standard devcontainer Feature: a `devcontainer-feature.json` (id, version, `options`, `installsAfter`) plus an `install.sh`. Existing ones: `buildifier`, `websocat` (in base); `mold` (cpp); `golang-wasi`, `nvidia-cuda` (polyglot).

`install.sh` conventions (see `buildifier/install.sh` as the template): `set -e`, detect `uname -m` and branch on `x86_64` vs `arm64`/`aarch64` (both arches are built), read the version from a `$VERSION` env var that defaults to the feature's `default`, download a release binary into `/usr/local/bin`, and `chmod +x`. Everything is built for **both amd64 and arm64**, so any new install logic must handle both.

## CI / publishing

`.github/workflows/ci.yml` triggers on pushes touching `images/**` or the workflow itself. For each image it runs a per-arch matrix (`ubuntu-latest` = amd64, `ubuntu-24.04-arm` = arm64), builds with `devcontainer build --push` tagged `:noble-<arch>`, then a follow-up `merge-*` job uses `docker buildx imagetools create` to publish the multi-arch `:noble` manifest. There is no test suite — CI *is* the build, and a green build means the image assembled successfully on both arches.

To validate an image build locally (requires the `@devcontainers/cli` and a parent image available):

```bash
devcontainer build --workspace-folder images/lot49-base
```

## Note on the repo's own devcontainer

`.devcontainer/devcontainer.json` (repo root) is the environment for *developing this repo* — it only needs the `devcontainers-cli` and a couple of utilities. It is unrelated to the images under `images/` and is not published.
