#!/bin/bash

if [ -f Nice.op ]; then
    rm Nice.op
fi

zip -r Nice.op . -x ".git/*" -x "build.sh" -x "exclude/*"