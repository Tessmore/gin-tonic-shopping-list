#!/usr/bin/env bash

yarn run build

cp ./src/assets/style.css ./docs/style.css
cp ./dist/build.js ./docs/build.js

npm --no-git-tag-version version patch
