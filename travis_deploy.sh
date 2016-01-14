#!/bin/bash
set -e
set -x

TAG=$TRAVIS_TAG
BRANCH=$TRAVIS_BRANCH
PR=$TRAVIS_PULL_REQUEST

echo $PR

if [ -z $TAG ]
then
    echo "No tags, tagging as: latest"
    TAG="latest"
fi

if [ $BRANCH = "master" ] # we also want to add -a $PR = "false" as we dont want to push PRs
then
    aws ecr get-login --region=us-east-1 | bash
    docker tag -f rapidpro_rapidpro:latest 387526361725.dkr.ecr.us-east-1.amazonaws.com/rapidpro:$TAG
    docker push 387526361725.dkr.ecr.us-east-1.amazonaws.com/rapidpro:$TAG

    fab stage preparedeploy

    # we never want our elastic beanstalk to use tag "latest" so if this is an
    # un-tagged build, use the commit hash
    if [ $TAG = "latest" ]
        TAG=$TRAVIS_COMMIT
    fi
    eb deploy -l $TAG
fi