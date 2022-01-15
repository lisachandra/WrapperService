#!/usr/bin/env bash

cd test

awk '$0 == "[dependencies]" {i=1;next};i && i >= 0' ../wally.toml > DEPENDENCIES.toml

cat DEPENDENCIES.toml >> wally.toml
wally install

if [ ! -d "Packages" ]; then
    mkdir Packages
    mkdir Packages/_Index
fi

declare -A DEPENDENCIES

while read line; do
    KEY=$(awk -v LINE="$line" -F '[@/"]' '{if (NR == LINE); print $2 "_" $3}' DEPENDENCIES.toml)
    VALUE=$(awk -v LINE="$line" '{if (NR == LINE); print $1}' DEPENDENCIES.toml)

    DEPENDENCIES+=(["$KEY"]="$VALUE")
done < DEPENDENCIES.toml

DEPENDENCIES_PATH_NAME=$(ls Packages/_Index)

mkdir Packages/_Index/zxibs_wrapperservice

cd Packages/_Index/zxibs_wrapperservice

for key in "${!DEPENDENCIES[@]}"; do
    DEPENDENCY_NAME=$(awk FS='_' '{print $2}' <<< "$key")
    DEPENDENCY_PATH_NAME=$(awk -v PATTERN="$key" '$0~PATTERN' <<< "$DEPENDENCIES_PATH_NAME")

    echo "return require(script.Parent.Parent['${DEPENDENCY_PATH_NAME}']['${DEPENDENCY_NAME}'])"
    echo "return require(script.Parent.Parent['${DEPENDENCY_PATH_NAME}']['${DEPENDENCY_NAME}'])" > "${DEPENDENCIES[${key}]}.lua"
done

cd ../../../..

cp -R src test/Packages/_Index/zxibs_wrapperservice/wrapperservice

echo 'return require(script.Parent._Index["zxibs_wrapperservice"]["wrapperservice"])' > test/Packages/WrapperService.lua