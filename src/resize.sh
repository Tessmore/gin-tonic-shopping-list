#!/bin/bash

find ./IMG/ -iname "*.jpg" | while IFS= read -r file; do
    echo "$file"
    convert "./$file" -auto-orient -resize "260x400>" -quality 100 "./${file%.JPG}"_min.jpg
done

mv ./IMG/*_min.jpg ./assets/