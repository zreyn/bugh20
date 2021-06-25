#!/bin/bash
set -e

docker run --rm -v ${PWD}:/repo \
    -e AWS_ACCESS_KEY_ID=$BUG_H20_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$BUG_H20_KEY \
    -e AWS_DEFAULT_REGION=us-east-2 \
    bugh20-deployer:latest \
    /repo/scripts/terraform-runner.sh