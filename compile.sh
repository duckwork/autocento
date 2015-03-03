# for windows only right now

num=0
for file in src/{.[!.]*,*}.txt; do
    # TODO: change this to work with globs & args & stuff
    echo -n "Compiling $file ..."
    pandoc -f markdown \
           -t html5 \
           --template=.template.html \
           --smart \
           --mathml \
           "$file" \
           -o "${file%.txt}.html"
    echo " Done."
    ((num += 1))
done

echo
echo "Moving files to build directory ..."
mv src/*.html ./
echo "Finished compiling $num files."
###############################################
echo
echo "Updating js/lozenge.js with file list ..."

lozengeList=( $(ls *.html) )

list=$(sed -e 's/\S\+\.html/"&",/g' -e 's/,$//' -e 's/^.*$/var files=[&]/' <<< "${lozengeList[@]}")

sed -i "s/var files=.*/$list/" js/lozenge.js

echo "Finished updating: ${#lozengeList[@]} files."
