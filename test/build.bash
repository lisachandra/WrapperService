#!/usr/bin/env bash

DEPENDENCIES=$(awk '$0 == "[dependencies]" {i=1;next};i && i >= 0' wally.toml)

cd test

echo "$DEPENDENCIES" >> wally.toml
wally install

cd ..

if [[ ! -d test/Packages ]]; then
    mkdir test/Packages
    mkdir test/Packages/_Index
fi

mkdir test/Packages/_Index/zxibs_wrapperservice

cp -R src test/Packages/_Index/zxibs_wrapperservice/wrapperservice
echo 'return require(script.Parent._Index["zxibs_wrapperservice"]["wrapperservice"])' > test/Packages/WrapperService.lua

rojo build test/auto.project.json -o test/wrapperservice-test.rbxlx
