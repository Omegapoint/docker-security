@echo off
echo ****************************************************
echo Check stats for a running container.
echo ****************************************************
echo Start a container with 256MB memory.
for /f "tokens=1" %%s in ('docker run --cpus=1 --memory="256m" --memory-swap="256m" -id busybox') do (set id=%%s)
echo Started container with id %id:~0,12%

echo.
echo ^> docker stats --no-stream %id:~0,12%
docker stats --no-stream %id%

echo.
echo Shut down container %id:~0,12%
docker container stop %id% > NUL
docker container rm %id% > NUL
@echo on