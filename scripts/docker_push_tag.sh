#!/bin/zsh

local -A opthash
zparseopts -D -A opthash -- -force f

if [[ -n "$opthash[(i)--force]" ]]; then
    FORCE_MODE=true
else
    FORCE_MODE=false
fi

if [ $# -ne 3 ]; then
    echo "Usage: $0 docker_image repository version"
    exit 1
fi

DOCKER_IMAGE=$1
REPOSITORY=$2
TAG=$3

if ! docker images -q | grep $DOCKER_IMAGE > /dev/null; then
    echo "Image($DOCKER_IMAGE) not exists."
    exit 1
fi

if [ $(`dirname $0`/docker_tag_exists.sh $REPOSITORY $TAG) = true ] && [ $FORCE_MODE = false ]; then
    echo "$REPOSITORY:$TAG already exists. skip"
    exit 0
fi

docker tag $DOCKER_IMAGE "$REPOSITORY:$TAG"
docker push "$REPOSITORY:$TAG"
