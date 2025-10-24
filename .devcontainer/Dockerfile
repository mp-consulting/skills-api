FROM ruby:3.3.6

# Install additional system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for development
RUN useradd -m -s /bin/bash vscode

# Ensure bundler is up to date
RUN gem update --system && gem install bundler

# Set working directory
WORKDIR /workspaces/skills-api

# Switch to non-root user
USER vscode

# Set Bundler paths to user-writable locations
ENV BUNDLE_PATH=/workspaces/skills-api/vendor/bundle
ENV BUNDLE_CACHE_PATH=/workspaces/skills-api/vendor/cache
