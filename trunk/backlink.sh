#!/bin/bash

# Command-line variables
searchQuery="$1";               # .html file to backlink
outFile="$2";                   # .back file to create
headerFile="$3";                # header information file
shift 3;
glob="$@";                      # where to search for backlinks

# Find backlinkers
echo -n "Back-linking \"$searchQuery\""
cat "$headerFile" > "$outFile";
grep -ql "$searchQuery" $glob >> "$outFile";

# Change title of $outFile
inText="`basename $searchQuery .html`.txt";
title=`grep '^title:' "$inText" | cut -d' ' -f2-`;
sed -i "s/_TITLE_/$title/" "$outFile";
echo -n "."

# Link to backlinks
for file in `grep '.html' "$outFile"`; do
    fText="`basename $file .html`.txt";
    title=`grep '^title:' $fText | cut -d' ' -f2-`;
    sed -i "s/^$file$/- [$title](&)/" "$outFile";
    echo -n "."
done

echo "Done."
