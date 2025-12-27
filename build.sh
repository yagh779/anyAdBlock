#!/bin/sh

zip -r -o -X -ll anyAdBlock_$(cat module.prop | grep 'version=' | awk -F '=' '{print $2}').zip ./ -x '.git/*' -x 'build.sh' -x '.github/*' -x 'aab.json'
