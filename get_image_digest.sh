#!/bin/bash

DOCKER_IMAGE=$1

if [[ $DOCKER_IMAGE == *"ghcr.io"* ]]; then
  IMAGE_NAME=$(echo "${DOCKER_IMAGE}" | awk -F/ '{print $NF}' | awk -F: '{print $1}')
  DOCKER_TAG=$(echo "${DOCKER_IMAGE}" | awk -F/ '{print $NF}' | awk -F: '{print $2}')
  DIGEST=$(curl -s -H "Accept: application/vnd.docker.distribution.manifest.v2+json" "https://ghcr.io/v2/${IMAGE_NAME}/manifests/${DOCKER_TAG}" | jq -r '.config.digest')
  IMAGE_NAME_WITH_TAG="${IMAGE_NAME}:${DOCKER_TAG}"
elif [[ $DOCKER_IMAGE == *"dkr.ecr."* ]]; then
  ACCOUNT=$(echo "${DOCKER_IMAGE}" | cut -d/ -f1)
  REGION=$(echo "${DOCKER_IMAGE}" | cut -d. -f4)
  REPO=$(echo "${DOCKER_IMAGE}" | cut -d/ -f2- | rev | cut -c 5- | rev)
  DOCKER_TAG=$(echo "${DOCKER_IMAGE}" | rev | cut -d: -f1 | rev)
  DIGEST=$(aws ecr batch-get-image --region "${REGION}" --repository-name "${REPO}" --image-ids imageTag="${DOCKER_TAG}" --query 'images[].imageId.imageDigest' --output text)
  IMAGE_NAME_WITH_TAG="${REPO}:${DOCKER_TAG}"
else
  IMAGE_NAME=$(echo "${DOCKER_IMAGE}" | awk -F: '{print $1}')
  DOCKER_TAG=$(echo "${DOCKER_IMAGE}" | awk -F: '{print $2}')
  TOKEN=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${IMAGE_NAME}:pull" | jq -r '.token')
  DIGEST=$(curl -s -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -H "Authorization: Bearer $TOKEN" "https://registry-1.docker.io/v2/${IMAGE_NAME}/manifests/${DOCKER_TAG}" | jq -r '.config.digest')
  IMAGE_NAME_WITH_TAG="${IMAGE_NAME}:${DOCKER_TAG}"
fi

echo "digest=${DIGEST}"
echo "image-name=${IMAGE_NAME_WITH_TAG}"
