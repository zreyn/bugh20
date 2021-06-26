#!/bin/bash
set -e

echo "authenticating to account"
docker_creds=$(docker run --rm -v ${PWD}:/repo \
                -e AWS_ACCESS_KEY_ID=$BUG_H20_KEY_ID \
                -e AWS_SECRET_ACCESS_KEY=$BUG_H20_KEY \
                -e AWS_DEFAULT_REGION=us-east-2 \
                bugh20-deployer:latest \
                /repo/scripts/ecr-auth.sh)
echo "retrieved docker credentials"

echo "authenticating docker to ecr"
echo -n "$docker_creds" | docker login --username AWS --password-stdin 078557663622.dkr.ecr.us-east-2.amazonaws.com
echo "authenticated docker to ecr"

echo "building lambda image"
image_name="tika-lambda:latest"
docker build -t "$image_name" -f lambdas/tika/Dockerfile lambdas/tika
echo "built lambda image"

echo "pushing lambda image to ecr"
docker tag $image_name "078557663622.dkr.ecr.us-east-2.amazonaws.com/tika-lambda:latest"
docker push "078557663622.dkr.ecr.us-east-2.amazonaws.com/tika-lambda:latest"
echo "pushed lambda image to ecr"
