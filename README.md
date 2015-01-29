#  Autocento of the breakfast table
## User guide and manual
## or whatever.  I don't care.

# Part I: in which our hero explains the goal

The goal in this book, *Autocento of the breakfast table*, is to explore the
workings of revision and recursion through words, both in the head and on
paper.  It's a hypertextual imagining of how things could have been, in all
of their possibilities.

# Part II: Enough of that high-faluting bullshit; down to brass tax
## A.K.A. Using Pandoc to compile them pages, neff

This project uses John MacFarlane's amazing, etc. [pandoc][] for the fun,
HTML-writing stuff. Use the `compile.sh` script to compile the stuff down.

*Note: you're on Windows right now, so make sure and type `bash compile.sh` to
run the program.*

At the top of each file, there should be a YAML block that looks something
like this:

````yaml
---
title: 'Title of poem or whatever'
subtitle: 'Subtitle, if it exists'
epigraph: 'Include epigraph here, if it exists'
epigraph-link: 'Link for the epigraph online (required)'
epigraph-credit: 'Credit for epigraph (optional)'
project: 'Original project here'
genre: 'Genre of file: [verse|prose]'
...
````

[pandoc]: http://johnmacfarlane.net/pandoc/
