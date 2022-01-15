#!/usr/bin/env bash

cd test

awk '$0 == "[dependencies]" {i=1;next};i && i >= 0' ../wally.toml > DEPENDENCIES.toml

cat DEPENDENCIES.toml >> wally.toml
wally install

if [ ! -d "Packages" ]; then
    mkdir Packages
    mkdir Packages/_Index
fi

awk -v q="'" -F '[ =@/"]' 'BEGIN {ORS=" "}; END {print "["q$5"_"$6q"]="q$1q}' DEPENDENCIES.toml

declare -A DEPENDENCIES=($(awk -v q="'" -F '[ =@/"]' 'BEGIN {ORS=" "}; END {print "["q$5"_"$6q"]="q$1q}' DEPENDENCIES.toml))
DEPENDENCIES_PATH_NAME=$(ls Packages/_Index)

mkdir Packages/_Index/zxibs_wrapperservice

cd Packages/_Index/zxibs_wrapperservice

for key in "${!DEPENDENCIES[@]}"; do
    DEPENDENCY_NAME=$(echo "$key" | awk -v -F'_' '{print $2}')
    DEPENDENCY_PATH_NAME=$(echo "$DEPENDENCIES_PATH_NAME" | awk -v PATTERN="$key" '$0~PATTERN')

    echo "${key} ${DEPENDENCY_NAME} ${DEPENDENCY_PATH_NAME} ${DEPENDENCIES[${key}]}"

    echo "return require(script.Parent.Parent['${DEPENDENCY_PATH_NAME}']['${DEPENDENCY_NAME}'])" > "${DEPENDENCIES[${key}]}.lua"
done

cd ../../../..

cp -R src test/Packages/_Index/zxibs_wrapperservice/wrapperservice

echo 'return require(script.Parent._Index["zxibs_wrapperservice"]["wrapperservice"])' > test/Packages/WrapperService.lua