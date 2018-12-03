@echo off
echo ****************************************************
echo Building an image from Dockerfile.
echo ****************************************************
setlocal
echo ^> docker build .
REM Save command output in temporary file so that we can parse it later.
docker build . > output
type output
REM Get image id from output.
for /f "tokens=3" %%s in ('type output ^| find "Successfully built"') do (set imageid=%%s)
REM Remove tempory file.
del output

echo.
echo Printing image layers using docker history.
echo ^> docker history %imageid%
docker history %imageid%
endlocal
@echo on