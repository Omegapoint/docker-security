#!/bin/sh
printf "****************************************************\n"
printf "Building an image for Java 8 from Dockerfile.\n"
printf "****************************************************\n"
printf "$ docker build -f Dockerfile-openjdk-8 .\n"
docker build -f Dockerfile-openjdk-8 . > output
cat output
imageid=$(cat output | grep "Successfully built" | egrep -o '[[:alnum:]]{12}$')
rm -f output
printf "\n"
printf "Run Java application without any parameters.\n"
docker run $imageid

printf "\n"
printf "Run Java application and reduce both cpu time and memory by 50%.\n"
docker run --cpu-shares 512 --memory 512m $imageid

printf "\n"
printf "Run Java application and use only CPU 0 and 512MB of memory.\n"
docker run --cpuset-cpus 0 --memory 512MB --env JAVA_OPT=“-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap“ $imageid