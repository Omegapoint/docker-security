#!/bin/sh
printf "****************************************************\n"
printf "This script creates two new virtual machines on Oracle Virtualbox called '%s' and '%s'.\n" "docker-security-1" "docker-security-2"
printf "'%s' is setup to be the default Docker Engine for the current terminal.\n"
printf "****************************************************\n"

printf "Creating a new virtual machine on Oracle Virtualbox called '%s'\n" "docker-security-1"
docker-machine create \
    --driver virtualbox \
    --virtualbox-cpu-count "2" \
    --virtualbox-memory "1024" \
    docker-security-1

printf "\n"
printf "Configuring '%s' as the Docker Engine for the current terminal." "docker-security-1"
eval $(docker-machine env docker-security-1)
printf "\n"
printf "Created machine 1/2"

printf "\n"
printf "Creating a new virtual machine on Oracle Virtualbox called '%s'\n" "docker-security-2"
docker-machine create --driver virtualbox docker-security-2
printf "\n"
printf "Created machine 2/2"

printf "\n"
printf "****************************************************\n"
printf "Setup DONE.\n"
printf "****************************************************\n"