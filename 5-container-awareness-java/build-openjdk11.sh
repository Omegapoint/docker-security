#!/bin/sh
printf "****************************************************\n"
printf "Building an image for Java 11 from Dockerfile.\n"
printf "****************************************************\n"
printf "$ docker build -f Dockerfile-openjdk-11 .\n"
docker build -f Dockerfile-openjdk-11 . > output
cat output
imageid=$(cat output | grep "Successfully built" | egrep -o '[[:alnum:]]{12}$')
rm -f output

printf "\n"
printf "Run Java application and limit both cpu time and memory with 50%.\n"
docker run --cpu-shares 512 --memory 512m $imageid

printf "\n"
printf "Run Java application and limit both cpu time and memory with 50% but disable container awareness.\n"
docker run --cpu-shares 512 --memory 512MB --env JAVA_OPT=-XX:-UseContainerSupport $imageid