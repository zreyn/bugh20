#!/bin/bash

set -e

echo "building deployer image"
docker build -t bugh20-deployer .
echo "built deployer image"
