#!/bin/zsh

if [[ $(arch) != "arm64" ]]; then
    echo "\e[31mThis script must be run on an arm64 machine.\e[m"
    exit 1
fi

DOCKER_USER=$1
IMAGE_NAME=$2
REPO_ROOT=$(git rev-parse --show-toplevel)

for version in $(cat $REPO_ROOT/.github/matrix.json | jq -r '.swift_version[]'); do
    # Less than 5.6 doesn't support arm64
    if [[ $(($version)) -lt 5.6 ]]; then
        continue
    fi

    docker manifest inspect $DOCKER_USER/$IMAGE_NAME:$version > /dev/null 2>/dev/null
    if [[ $? -ne 0 ]]; then
        # Pull amd64 image and re-tag
        docker pull --platform=linux/amd64 $DOCKER_USER/$IMAGE_NAME:$version
        AMD64_IMAGE_ID=$(docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep $DOCKER_USER/$IMAGE_NAME:$version | grep -v arm64 | awk '{print $2}')
        docker tag $AMD64_IMAGE_ID $DOCKER_USER/$IMAGE_NAME:$version-amd64
        docker push $DOCKER_USER/$IMAGE_NAME:$version-amd64

        # Build arm64 image
        docker build --build-arg SWIFT_VERSION=$version -t $DOCKER_USER/$IMAGE_NAME:$version-arm64 -f $REPO_ROOT/Dockerfile $REPO_ROOT
        docker push $DOCKER_USER/$IMAGE_NAME:$version-arm64

        # Create manifest
        docker manifest create $DOCKER_USER/$IMAGE_NAME:$version \
            $DOCKER_USER/$IMAGE_NAME:$version-amd64 \
            $DOCKER_USER/$IMAGE_NAME:$version-arm64
        docker manifest push $DOCKER_USER/$IMAGE_NAME:$version

        # Clean up
        docker image rm $DOCKER_USER/$IMAGE_NAME:$version \
            $DOCKER_USER/$IMAGE_NAME:$version-amd64 \
            $DOCKER_USER/$IMAGE_NAME:$version-arm64

        # Clean up on Docker Hub
        DOCKER_HUB_TOKEN=`curl -s -H "Content-Type: application/json" -X POST -d "{\"username\": \"$DOCKER_USER\",\"password\": \"$DOCKER_HUB_PASSWORD\"}" "https://hub.docker.com/v2/users/login/" | jq -r .token`
        curl "https://hub.docker.com/v2/repositories/${DOCKER_USER}/${IMAGE_NAME}/tags/${version}-amd64/" \
            -X DELETE \
            -H "Authorization: JWT ${DOCKER_HUB_TOKEN}"
        curl "https://hub.docker.com/v2/repositories/${DOCKER_USER}/${IMAGE_NAME}/tags/${version}-arm64/" \
            -X DELETE \
            -H "Authorization: JWT ${DOCKER_HUB_TOKEN}"
    fi
done
