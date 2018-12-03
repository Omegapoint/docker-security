#!/bin/sh
printf "****************************************************"
printf "Testing content trust feature."
printf "****************************************************"
printf "Enabling Docker Content Trust for the current terminal session.\n"
printf "$ export DOCKER_CONTENT_TRUST=1\n"
export DOCKER_CONTENT_TRUST=1
printf "\n"
printf "Try pulling an untrusted (i.e. unsigned) image.\n"
printf "$ docker pull docker/trusttest\n"
docker pull docker/trusttest

printf "\n"
printf "Try pulling a trusted (i.e. signed/official) image.\n"
printf "$ docker pull busybox\n"
docker pull busybox