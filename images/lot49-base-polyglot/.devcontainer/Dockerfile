FROM ghcr.io/lot49-cybernetics/lot49-base-cpp:noble

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Add deadsnakes PPA and install Python.
    && apt-get install --no-install-recommends -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends -y python3.14 python3.14-dev python3.14-venv \
    # Cleanup.
    && rm -rf /tmp/* \
    && apt-get autoremove -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*
