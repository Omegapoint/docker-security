@echo off
echo ****************************************************
echo Testing content trust feature.
echo ****************************************************

echo Enabling Docker Content Trust for the current terminal session.
echo ^> export DOCKER_CONTENT_TRUST=1
set DOCKER_CONTENT_TRUST=1

echo.
echo Try pulling an untrusted (i.e. unsigned) image.
echo ^> docker pull docker/trusttest
docker pull docker/trusttest

echo.
echo Try pulling a trusted (i.e. signed/official) image.
echo ^> docker pull busybox
docker pull busybox

@echo on