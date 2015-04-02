#!/bin/bash

file="$1";
headFile="$2";
shift 2;
glob="$@";                       # *.hapax

tempFile="${RANDOM}.tmp"

echo -n "Linking \"$file\""
# Begin
cat "$headFile" > "$tempFile";
echo -n "."
# Link words to files they appear in
for word in `sort "$file"`; do
    f=`grep -liwq "^$word$" $glob`;
    link="`basename $f .hapax`.html"
    echo "[$word]($link)" >> "$tempFile";
    echo -n "."
done

# Make the changes happen
rm "$file"
mv "$tempFile" "$file"

echo "Done."
