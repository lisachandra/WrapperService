#!/usr/bin/env bash

awk '$0 == "[dependencies]" {i=1;next};i && i >= 0' wally.toml > test/DEPENDENCIES.toml

cd test

cat DEPENDENCIES.toml >> wally.toml
wally install

DEPENDENCIES_LIST=$(ls Packages/_Index)

cd ..

declare -A DEPENDENCIES

while IFS= read -r line; do
    KEY=$(awk -v LINE="$line" -F'[@/"]' '{if (NR == LINE); print $2 "_" $3}' DEPENDENCIES.toml)
    VALUE=$(awk -v LINE="$line" '{if (NR == LINE); print $1}' DEPENDENCIES.toml)

    DEPENDENCIES+=([${KEY}]=${VALUE})
done < test/DEPENDENCIES.toml

if [ ! -d "test/Packages" ]; then
    mkdir test/Packages
    mkdir test/Packages/_Index
fi

mkdir test/Packages/_Index/zxibs_wrapperservice

cd test/Packages/_Index/zxibs_wrapperservice

for key in ${!DEPENDENCIES[@]}; do
    DEPENDENCY_NAME=$(echo "$key" | awk -v FS=_ 'print $2')
    DEPENDENCY_PATH_NAME=$(echo "$DEPENDENCIES_LIST" | awk -v PATTERN="$key" '$0~PATTERN')

    echo "return require(script.Parent.Parent['${DEPENDENCY_PATH_NAME}']['${DEPENDENCY_NAME}'])" > "${DEPENDENCIES[${key}]}.lua"
done

cd ../../../..

cp -R src test/Packages/_Index/zxibs_wrapperservice/wrapperservice

echo 'return require(script.Parent._Index["zxibs_wrapperservice"]["wrapperservice"])' > test/Packages/WrapperService.lua