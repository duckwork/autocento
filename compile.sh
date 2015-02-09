# for windows only right now

for file in src/*.txt; do # TODO: change this to work with globs & args & stuff
    echo -n "Compiling $file ..."
    pandoc -f markdown \
           -t html5 \
           --template=_template.html \
           --smart \
           $file \
           -o "${file%.txt}.html"
    echo " Done."
done

echo "Moving files to build directory ..."
mv src/*.html ./
