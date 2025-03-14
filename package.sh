#!/bin/bash
pushd "${0%/*}" > /dev/null 
if [ ! -z $APPVEYOR_BUILD_NUMBER ]; then _BuildProp="/p:BuildNumber=$APPVEYOR_BUILD_NUMBER"; fi
if [ ! -z $APPVEYOR_BUILD_VERSION ]; then _VersionProp="/p:VersionPrefix=$APPVEYOR_BUILD_VERSION"; fi
dotnet restore
dotnet msbuild /t:clean,restore,build /p:Configuration=Debug /p:TargetFramework=netcoreapp2.1 $_BuildProp $_VersionProp $@
dotnet msbuild /t:clean,restore,build,package /p:Configuration=Release /p:TargetFramework=netcoreapp2.1 $_BuildProp $_VersionProp $@
popd
