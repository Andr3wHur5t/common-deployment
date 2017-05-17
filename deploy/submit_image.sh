#!/usr/bin/env bash

# Should be set to 0 in prod; use this for debugging issues though;
INTERNAL_DEBUG=0

# Force abort and trap exit code...
set -e

# Tag is the first parameter
ECR_REGION=$1
ECR_URL=$2
LOCAL_NAME=$3
CURRENT_TAG=$4

helpExit () {
  echo -e "Must set the '$1' example usage './submit_image.sh <ecr-region> <ecr-uri> <local-image> <remote-tag>'\n\n"
  exit 1
}

if [ -z "$ECR_REGION" ]; then helpExit 'ecr-region'; fi
if [ -z "$ECR_URL" ]; then helpExit 'ecr-uri'; fi
if [ -z "$LOCAL_NAME" ]; then helpExit 'local-image'; fi
if [ -z "$CURRENT_TAG" ]; then helpExit 'remote-tag'; fi

### Check that required executables exist ###
if [ ! -x $(which aws) ] ; then
    echo "AWS must exist!"
    exit 1
fi

if [ ! -x $(which docker) ] ; then
    echo "Docker must exist!"
    exit 1
fi

### Get these values when you setup ECR ###
ECR_REGION="${ECR_REPO_REGION}"
ECR_IMAGE_URL="${ECR_URL}:${CURRENT_TAG}"

if [ ! ${INTERNAL_DEBUG} -eq "0" ] ; then
    echo -e "Printing vars: \n===="

    echo "CURRENT_TAG == '${CURRENT_TAG}'"
    echo "ECR_REGION == '${ECR_REGION}'"
    echo "REPO_NAME == '${REPO_NAME}'"
    echo "TAGGED_NAME == '${TAGGED_NAME}'"
    echo "ECR_URL == '${ECR_URL}'"

    echo -e "==== \n"
fi

# Get the login creds from aws and give them to bash; kinda eval but it works...
echo "Getting repo credentials from AWS..."
aws ecr get-login --region ${ECR_REGION} | bash -e

echo "Tagging image ${LOCAL_NAME} as ${ECR_IMAGE_URL}"
docker tag "${LOCAL_NAME}" "${ECR_IMAGE_URL}"

echo "pushing to ${ECR_IMAGE_URL}"
docker push "${ECR_IMAGE_URL}"
echo "SUCESS: Pushed!!!"

exit 0; # All good let it roll!

