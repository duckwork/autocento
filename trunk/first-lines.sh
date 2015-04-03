#!/bin/bash

outFile="$1";
header="$2";
shift 2;
glob="$@";

firstLineOf() { # $1 = file
    endOfYaml=$(sed -n '/^\.\.\.$/=' "$1")
    tryLineNumber=$((endOfYaml + 1))
    try=""
    while [[ -z $try ]]; do
        try=$(head -n $tryLineNumber "$1" | tail -n 1 |\
              sed -e 's/^[|>] //' -e 's/[][]//g' -e 's/^#.*//' -e 's/^--.*//')
        (( tryLineNumber += 1 ))
    done
    echo "$try"
}

echo -n "Compiling ${outFile}..."
cat "$header" > $outFile

for file in $glob; do
    # Copy first line to $outFile & link
    echo "[$(firstLineOf "$file")](${file%.*}.html)" >> $outFile
done
echo "Done."
