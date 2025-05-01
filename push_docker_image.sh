#!/bin/bash
# This script builds a Docker image and pushes it to an AWS ECR repository.
region="us-east-1"
repository_name="awfiz"
account_id="145023118191"
tag="1.0"

# Retrieve an authentication token and authenticate your Docker client to your registry.
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com

# Build your Docker image using the following command.
docker build -t ${repository_name}:${tag} .

# Tag your image so you can push the image to this repository:
docker tag ${repository_name}:${tag} ${account_id}.dkr.ecr.${region}.amazonaws.com/${repository_name}:${tag}

#push this image AWS repository:
docker push ${account_id}.dkr.ecr.${region}.amazonaws.com/${repository_name}:${tag}

# List images in the repository
aws ecr list-images --repository-name ${repository_name} --region ${region}