# Use Amazon Corretto 21 (Amazon Linux base)
FROM amazoncorretto:21

# Install necessary dependencies (Amazon Linux uses yum)
RUN yum update -y && yum install -y \
    curl \
    zip \
    unzip \
    git \
    graphviz \
    nodejs \
    npm \
    bash \
    && yum clean all

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

ADD start.sh start.sh

# Default command
CMD ["bash", "start.sh"]
