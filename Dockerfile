# Stage 1: Extract the ZeroClaw static binary
FROM ghcr.io/zeroclaw-labs/zeroclaw:v0.1.7 AS zeroclaw-base

# Stage 2: Build our custom image with tools
FROM ubuntu:24.04

# Install basic components including Node.js for npm
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Bruno CLI via npm instead of curl script
RUN npm install -g @usebruno/cli


# Copy ZeroClaw binary
COPY --from=zeroclaw-base /usr/local/bin/zeroclaw /usr/local/bin/zeroclaw

# Setup user and permissions
RUN useradd -m -d /zeroclaw-data -s /bin/bash zeroclaw
USER zeroclaw

# Environment configuration
ENV HOME=/zeroclaw-data
ENV ZEROCLAW_ALLOW_PUBLIC_BIND=true
WORKDIR /zeroclaw-data

# Match the official entrypoint and default command
ENTRYPOINT ["zeroclaw"]
CMD ["daemon"]
