#!/usr/bin/env bash

EXIT_CODE=0

while true; do
    run-in-roblox --place test/wrapperservice-test.rbxlx --script test/runner.server.lua > output.txt

    if [ ! -z "$(grep 'test nodes reported failures.' 'output.txt')" ]; then 
        EXIT_CODE=1
        break
    elif [ "$(echo $?)" == '0' ]; then
        break
    fi

    cat output.txt
done

cat output.txt

exit "$EXIT_CODE"
