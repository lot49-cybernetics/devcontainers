# Lot49 VS Code Devcontainers

This repo contains Lot49's base [devcontainers](https://containers.dev) for [VS Code](https://code.visualstudio.com/).

- `lot49-base`: base features like pre-commit and various common linting and security tools to support [Left of Launch](https://mirror.xyz/0x46c5bBA2274211f81bC810bc227810Ac014d0BA6/SZ5f-VKdMcwWxE_PiFTQcFF-qx9c3rp-vG-b71V6uhc) quality checks
- `lot49-base-deploy`: additional features for CI/CD and Kubernetes support, for deployable projects
- `lot49-base-cpp`: additional features specifically for C/C++ projects
- `lot49-base-polyglot`: expanded to support C/C++, Go, Python, TypeScript, Rust and Zig, plus Bazel, LaTeX documentation, WASM tooling and Protobuf support

Each stacks on top of the other, and at the very bottom is `mcr.microsoft.com/devcontainers/base:noble` -- the Ubuntu 'Noble' base devcontainer from Microsoft. 
