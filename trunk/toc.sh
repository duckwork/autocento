#!/bin/bash

outFile="$1";
shift 1;
glob="$@";

echo -n "Compiling $outFile"

for file in $glob; do
    title=$(grep '^title: ' $file | cut -d' ' -f2-);
    subtitle=$(grep '^subtitle: ' $file | cut -d' ' -f2-);
    htmlFile="${file%.txt}.html"
    # if [[ "$title" == "Autocento of the breakfast table" ]]; then
    #     echo "#. [$subtitle]($htmlFile)" >> "$outFile";
    # else
    #     echo "#. [$title]($htmlFile)" >> "$outFile";
    # fi
    if [[ -n "$subtitle" ]]; then
        echo "#. [$title: $subtitle]($htmlFile)" >> "$outFile"
    else
        echo "#. [$title]($htmlFile)" >> "$outFile";
    fi
    echo -n "."
done

echo "Done."
