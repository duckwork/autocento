#!/bin/bash

outFile="$1";
shift;
fileList="$@";

echo -n "Updating \"lozenge.js\"..."

list=`echo ${fileList[@]} |\
      sed -e 's/\(\S\+.html\) \?/"\1",/g'\
          -e 's/^\(.*\),$/var files=[\1]/'`

sed -i "s/var files=.*/$list/" "$outFile";

echo "Done."
