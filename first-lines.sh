#!/bin/bash

outFile=src/first-lines.txt

echo "" > $outFile

for file in src/*.txt; do
    echo -n "Getting first line of $file .. "
    endOfYAML=$(sed -n '/^\.\.\.$/=' "$file")
    firstLineNumber=$((endOfYAML + 2))

    echo "$file: " >> $outFile
    echo "      $(head -n $firstLineNumber "$file" | tail -n 1)" >> $outFile

    unset endOfYAML firstLineNumber
    echo "Done."
done
