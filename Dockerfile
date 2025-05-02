FROM openjdk:11-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    git \
    graphviz \
    nodejs \
    npm \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Detect architecture and install appropriate AWS CLI version
RUN if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    else \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    fi && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Set up working directory
WORKDIR /app

ADD run.sh run.sh

# Set default command
CMD ["bash", "run.sh"]