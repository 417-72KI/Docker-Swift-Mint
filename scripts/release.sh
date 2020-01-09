#!/bin/zsh

IMAGE_NAME=$1
DOCKER_HUB_USER='41772ki'
DOCKER_HUB_REPO='swift-mint'

# Get Image ID
IMAGE_ID=$(docker images | grep ${IMAGE_NAME} | awk '{ print $3 }')

function push_tag() {
    docker tag "$IMAGE_ID" "${DOCKER_HUB_USER}/${DOCKER_HUB_REPO}:$1"
    docker push "${DOCKER_HUB_USER}/${DOCKER_HUB_REPO}:$1"
}

push_tag latest

# refs: https://stackoverflow.com/questions/7516455/sed-extract-version-number-from-string-only-version-without-other-numbers
SWIFT_VERSION=$(docker run ${IMAGE_NAME} swift --version | grep 'Swift version' | sed 's/[^0-9.]*\([0-9.]*\).*/\1/')

push_tag $SWIFT_VERSION
push_tag $(echo $SWIFT_VERSION | sed -E 's/([0-9]*)\.([0-9]*)\.([0-9]*)/\1.\2/g')
push_tag $(echo $SWIFT_VERSION | sed -E 's/([0-9]*)\.([0-9]*)\.([0-9]*)/\1/g')
