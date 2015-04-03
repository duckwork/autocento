#!/bin/bash

# Command-line variables
searchQuery="$1";               # .html file to backlink
outFile="$2";                   # .back file to create
headerFile="$3";                # header information file
islandHead="$4";
shift 4;
glob="$@";                      # where to search for backlinks

islandLink="island"
[[ ! -f ${islandLink}.txt ]] && cat "$islandHead" > ${islandLink}.txt;

# Find backlinkers
echo -n "Back-linking \"$searchQuery\""
cat "$headerFile" > "$outFile";
if ! grep -ql "$searchQuery" $glob >> "$outFile"; then
    echo "[_island_](${islandLink}.htm)." >> "$outFile";
    title=`grep '^title:' "${searchQuery%.html}.txt" | cut -d' ' -f2-`;
    echo "- [$title]($searchQuery)" >> "${islandLink}.txt"
fi

# Change title & id of $outFile
inText="`basename $searchQuery .html`.txt";
title=`grep '^title:' "$inText" | cut -d' ' -f2-`;
id=`grep '^id:' "${searchQuery%.html}.txt" | cut -d' ' -f2`;
sed -i "s/_TITLE_/$title/" "$outFile";
sed -i "s/_ID_/$id/" "$outFile";
echo -n "."

# Change *.txt to *.html
sed -i 's/^\(.*\)\.txt/\1.html/g' "$outFile";

# Link to backlinks
for file in `grep '.html$' "$outFile"`; do
    fText="`basename $file .html`.txt";
    title=`grep '^title:' $fText | cut -d' ' -f2-`;
    sed -i "s/^$file$/- [$title](&)/" "$outFile";
    echo -n "."
done

echo "Done."
