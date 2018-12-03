@echo off
echo ****************************************************
echo This script creates two new virtual machines on Oracle Virtualbox called 'docker-security-1' and 'docker-security-2'. 
echo 'docker-security-1' is setup to be the default Docker Engine for the current terminal.
echo ****************************************************

echo.
echo Creating a new virtual machine on Oracle Virtualbox called 'docker-security-1'.
echo ^> docker-machine create --driver virtualbox --virtualbox-cpu-count ^"2^" --virtualbox-memory ^"1024^" docker-security-1
docker-machine create --driver virtualbox --virtualbox-cpu-count "2" --virtualbox-memory "1024" docker-security-1

echo.
echo Configuring 'docker-security-1' as the Docker Engine for the current terminal.
REM echo ^> @FOR /f ^"tokens=*^" %%i IN ('docker-machine env docker-security-1') DO @%%i
@FOR /f "tokens=*" %%i IN ('docker-machine env docker-security-1') DO @%%i
echo  Created machine 1/2

echo.
echo Creating a new virtual machine on Oracle Virtualbox called 'docker-security-2'.
echo ^> docker-machine create --driver virtualbox docker-security-2
docker-machine create --driver virtualbox docker-security-2
echo Created machine 2/2

echo.
echo ****************************************************
echo Setup DONE.
echo ****************************************************
@echo on