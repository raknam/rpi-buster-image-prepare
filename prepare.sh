#!/bin/bash

docker build -t packer-builder-arm packer-builder-arm-image
docker run \
  --rm \
  --privileged \
  -v ${PWD}:/build:ro \
  -v ${PWD}/packer_cache:/build/packer_cache \
  -v ${PWD}/output:/build/output \
  packer-builder-arm build -debug rpi-zero.json
