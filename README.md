Autocento of the breakfast table: a README
==========================================

Part I: in which our hero explains the goal
-------------------------------------------

The goal in this book, *Autocento of the breakfast table*, is to explore the workings of revision and recursion through words, both in the head and on paper.
It's a hypertextual imagining of how things could have been, in all of their possibilities.

Part II: How to use this repo
-----------------------------

This project uses John McFarlane's wonderful program [pandoc][], and its markdown flavor, to encode the poems and stories and things contained within.
To see the source text files, navigate to the [src/](autocento.me/src/) folder.

At the top of each file, there is a YAML metadata block that looks something like this:

````yaml
---
title: Title of poem
subtitle: Subtitle                           # optional
genre: verse                                 # verse or prose

epigraph:                                    # optional
- content: 'Content of epigraph'             # req'd if epigraph exists
  link: 'http://link-to-epigraph-source/'    # optional
  attrib: 'Epigraph attribution'             # optional

dedication: my mother                        # optional

ekphrastic:                                  # optional image ekphrastic
    image: 'link-to-image.ext'
    title: 'Text for title text of image'
    link: 'http://link-to-host-of-original/'

project:
    title: Original project name
    order: 1                                 # page number, optional
    prev:                                    # optional
    - title: Title of previous thing in original project
      link: link to that thing
    - title: Title of other previous thing
      link: link to that thing
    next:                                    #optional
    - title: Title of next thing in original project
      link: link to that thing
    - title: Title of other next thing
      link: link to that thing
...
````

To compile all the markdown into glorious, glorious HTML (visible at <http://autocento.me>), run `compile.lua` (`bash compile.lua` in Windows) in the root directory of this git repository.

[pandoc]: http://johnmacfarlane.net/pandoc/
