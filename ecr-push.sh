#!/bin/bash

# Set variables
#export AWS_REGION=your-region
#export AWS_ACCOUNT_ID=your-aws-account-id
#export ECR_REPOSITORY_NAME=sokrates-landscape
#export IMAGE_TAG=latest

# Create ECR repository (if it doesn't exist)
aws ecr describe-repositories --repository-names $ECR_REPOSITORY_NAME --region $AWS_REGION || \
aws ecr create-repository --repository-name $ECR_REPOSITORY_NAME --region $AWS_REGION

# Authenticate Docker to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag the Docker image
docker tag $ECR_REPOSITORY_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:$IMAGE_TAG

# Push the Docker image to ECR
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:$IMAGE_TAG

echo "Successfully pushed $ECR_REPOSITORY_NAME:$IMAGE_TAG to Amazon ECR"