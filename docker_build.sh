#!/bin/bash

docker buildx build --push --platform linux/amd64 -f Dockerfile -t pmallozzi/devenvs:robogrammar --push . --no-cache
