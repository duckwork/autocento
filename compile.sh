# for windows only right now

for file in *.txt; do # TODO: change this to work with globs & args & stuff
    pandoc -f markdown \                 # all files are in pandoc's markdown
           -t html5 \                    # they're being outputted to html5
           --template=_template.html \   # use this file as a template
           --smart \                     # smart quotes, etc.
           $file \
           -o "${file%.txt}.html"
done
