@echo off
echo ****************************************************
echo Building an image for Java 11 from Dockerfile.
echo ****************************************************
echo ^> docker build -f Dockerfile-openjdk-11 .
REM Save command output in temporary file so that we can parse it later.
docker build -f Dockerfile-openjdk-11 . > output
type output
REM Get image id from output.
for /f "tokens=3" %%s in ('type output ^| find "Successfully built"') do (set imageid=%%s)
REM Remove tempory file.
del output

echo 
echo Run Java application and limit both cpu time and memory with 50%.
docker run --cpu-shares 512 --memory 512m %imageid%

echo 
echo Run Java application and limit both cpu time and memory with 50% but disable container awareness.
docker run --cpu-shares 512 --memory 512MB --env JAVA_OPT=-XX:-UseContainerSupport %imageid%
@echo on