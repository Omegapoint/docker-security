@echo off
echo ****************************************************
echo Cleaning up. All virtual machines created in this session will be removed.
echo ****************************************************
echo ^> docker-machine rm -f docker-security-1
docker-machine rm -f docker-security-1
echo Removed machine 1/2

echo.
echo ^> docker-machine rm -f docker-security-2
docker-machine rm -f docker-security-2
echo Removed machine 2/2

echo.
echo ****************************************************
echo Clean up DONE.
echo ****************************************************
@echo on