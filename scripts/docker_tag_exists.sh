#!/bin/zsh

if [ $# -ne 2 ]; then
    echo "Usage: $0 repository version"
    exit 1
fi

REPOSITORY=$1
TAG=$2

if [ $(curl -s https://registry.hub.docker.com/v1/repositories/$REPOSITORY/tags | jq ".[] | .name | select(. == \"$TAG\")") ]; then
    echo true
else
    echo false
fi
