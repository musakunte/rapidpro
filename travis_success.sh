#!/bin/bash
set -e
set -x

TAG=$(git describe --tags $(git rev-parse HEAD))
BRANCH=$(git branch | grep "^*" | cut -d" " -f2)

if [ -z $TAG ]
then
    echo "No tags, tagging as: latest"
    TAG="latest"
fi

if [ $BRANCH = "feature/nathan/dockerize" ]
then
    aws ecr get-login --region=us-east-1 | bash
    docker tag -f rapidpro_rapidpro:latest 387526361725.dkr.ecr.us-east-1.amazonaws.com/rapidpro:$TAG
    docker push 387526361725.dkr.ecr.us-east-1.amazonaws.com/rapidpro:$TAG
fi
