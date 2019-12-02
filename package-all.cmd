@echo off
SET _DOCKER_BUILD="true"
docker -v > NUL
if not errorlevel 0 (
    echo Linux RPM and DEB packaging requires a docker install
    SET _DOCKER_BUILD="false"
)
echo *** Sanity check Windows
dotnet restore 
dotnet test %*
if not errorlevel 0 exit /b 1
echo *** Building and packaging Windows Targets

if %_DOCKER_BUILD% == "true" (
   echo *** Windows only
   msbuild /t:clean,restore,package /p:WindowsOnly=true;Configuration=Release %*
) else (
    echo *** All platforms
    msbuild /t:clean,restore,package /p:WindowsOnly=false;Configuration=Release %*
)

if not errorlevel 0 exit /b 1
if %_DOCKER_BUILD% == "true" (
  echo *** Building and packaging Unix/Linux Targets
  docker run --rm -v %cd%:/build mcr.microsoft.com/dotnet/core/sdk:3.0-buster /build/package.sh /p:TargetFramework=netcoreapp3.0 %*
)