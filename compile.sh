# for windows only right now

num=0
for file in src/*.txt; do # TODO: change this to work with globs & args & stuff
    echo -n "Compiling $file ..."
    pandoc -f markdown \
           -t html5 \
           --template=_template.html \
           --smart \
           --mathjax \
           $file \
           -o "${file%.txt}.html"
    echo " Done."
    ((num += 1))
done

echo "Moving files to build directory ..."
mv src/*.html ./
echo
echo "Finished compiling $num files."
