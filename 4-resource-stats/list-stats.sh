#!/bin/sh
printf "****************************************************\n"
printf "Check stats for a running container.\n"
printf "****************************************************\n"
printf "Start a container with 256MB memory.\n"
docker run --cpus=1 --memory="256m" --memory-swap="256m" -id busybox > containerid
id=$(cat containerid)
printf "Started container with id %.12s\n" $id
rm containerid
printf "\n"
printf "$ docker stats --no-stream %.12s\n" $id
docker stats --no-stream $id
printf "Shut down container %12s\n" $id
docker container stop $id
docker container rm $id