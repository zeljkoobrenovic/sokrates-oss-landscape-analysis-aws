FROM openjdk:11-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    graphviz \
    nodejs \
    npm \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Set up working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/zeljkoobrenovic/sokrates-oss-landscape-analysis-aws.git /app

RUN rm /app/analysis-scripts/config.json

# Download the Sokrates CLI JAR
RUN curl https://d2bb1mtyn3kglb.cloudfront.net/builds/sokrates-LATEST.jar --output sokrates-LATEST.jar

# Create a volume for config and output
VOLUME ["/app/analysis-scripts/config.json", "/app/analysis-artifacts"]

# Set default command
CMD ["bash", "run.sh"]