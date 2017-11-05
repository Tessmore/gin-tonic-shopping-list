#!/usr/bin/env bash

NODE_ENV=production ./node_modules/webpack/bin/webpack.js --progress --hide-modules

cp ./src/assets/style.css ./docs/style.css
cp ./dist/build.js ./docs/build.js

npm --no-git-tag-version version patch
