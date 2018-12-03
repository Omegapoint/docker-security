#!/bin/sh
printf "****************************************************\n"
printf "Cleaning up. All virtual machines created in this session will be removed.\n"
printf "****************************************************\n"
docker-machine rm -f docker-security-1
printf "\n"
printf "Removed machine 1/2"
docker-machine rm -f docker-security-2
printf "\n"
printf "Removed machine 2/2"

printf "\n"
printf "****************************************************\n"
printf "Clean up DONE."
printf "****************************************************\n"