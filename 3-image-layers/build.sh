#!/bin/sh
printf "Building an image from Dockerfile.\n"
printf "$ docker build .\n"
# Save command output in temporary file so that we can parse it later.
docker build . > output
cat output
# Get image id from output.
imageid=$(cat output | grep "Successfully built" | egrep -o '[[:alnum:]]{12}$')
# Remove tempory file.
rm -f output

printf "\n"
printf "Printing image layers using docker history.\n"
printf "$ docker history %s\n" "$imageid"
docker history $imageid