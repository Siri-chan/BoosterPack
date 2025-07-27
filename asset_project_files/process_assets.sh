#! /bin/bash -v

# Space-separated
INPUTS=" Seals-fell_for_it_again.kra"

mkdir -p ./out/1x ./out/2x
for file in $INPUTS ; do
    rm "$file~"
    krita "$file" --export --export-filename "./out/1x/${file%.kra}.png"
    magick "./out/1x/${file%.kra}.png" -resize 200% "./out/2x/${file%.kra}.png"
done
