#!/usr/bin/env bash

EXIT_CODE=0

while true; do
    run-in-roblox --place test/wrapperservice-test.rbxlx --script test/runner.server.lua > output.txt

    if grep -q '\[-\] Tests' 'output.txt'; then 
        EXIT_CODE=1
        break
    elif grep -q '\[+\] Tests' 'output.txt'; then
        break
    fi
done

cat output.txt

exit "$EXIT_CODE"
