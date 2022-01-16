#!/usr/bin/env bash

cd test

awk '$0 == "[dependencies]" {i=1;next};i && i >= 0' ../wally.toml >> wally.toml
wally install

if [ ! -d "Packages" ]; then
    mkdir Packages
    mkdir Packages/_Index
fi

mkdir Packages/_Index/zxibs_wrapperservice

cd ..

cp -R src test/Packages/_Index/zxibs_wrapperservice/wrapperservice

ls test/Packages

echo 'return require(script.Parent._Index["zxibs_wrapperservice"]["wrapperservice"])' > test/Packages/WrapperService.lua