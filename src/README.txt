---
title: Autocento of the breakfast table
subtitle: about this site
genre: prose

epigraph:
    content: by Case Duckworth

project:
    title: Autocento of the breakfast table
    css: autocento
...

Introduction
------------

_Autocento [of the breakfast table][]_ is a hypertextual exploration of the workings of revision across time.
Somebody^[_[citation needed][]_]^ once said that every relationship we have is part of the same relationship; the same is true of authorship.
As we write, as we continue writing across our lives, patterns thread themselves through our work: images, certain phrases, preoccupations.
This project attempts to make those threads more apparent, using the technology of hypertext.

I'm also an MFA candidate at [Northern Arizona University][NAU].
This is my thesis.

Process
-------

In compiling the works that make up this text, I've pulled from a few different projects:

* [Elegies for alternate selves](and.html)
* [The book of Hezekiah](prelude.html)
* [Stark raving](table_contents.html)
* [Buildings out of air](art.html)

as well as added new articles, written quite recently.
As I've compiled them into this project, I've linked them together based on common images or language, moving back and forth through time.
This should give the reader a fair idea of what my head looks like on the inside.

Technology
----------

Because this project lives online, I've used a fair amount of technology to get it there.
First, I converted all the articles[^1] present into plain text files, which are viewable [here][text].
Then, I used John McFarlane's venerable document preparation system [pandoc][], along with a short [script][compile.lua], to compile the text sources to HTML using [this template][].
The compiled HTML is what you're reading now.[^2]

To host the project, I'm using [Github][], an online code-collaboration tool with the version control system [git][] under the hood.
This enables me (and you, dear Reader!) to explore the path of revision even more, from beginning to end, based on my commits to the repository.
You can view the repository and its changes and files at [my Github profile][].[^3]

Using this site
---------------

All of the articles on this site are linked together hypertextually (i.e., like a webpage).
This means that all you need to do to explore the creative threads linking these articles together is to start clicking links.
However, if you find you're looping around to a lot of the same articles, you can head back to the [index][] and click through the titles in order---that article contains the titles of all the other works in this project.

Alternatively, you can click the lozenge (&loz;) at the bottom of each page.
It'll take you to a random article in the project, thanks to [this javascript][].

If you want to experience the earlier projects in something resembling the original orders, previous and next links are provided at the bottom of each page, next to the lozenge.
Sometimes, there are more than one of each of these, or there are none, dependant on the structure of their original project.

Things still to do
------------------

_Autocento of the breakfast table_ is a work in progress.
The first draft is completed, but some revision and aesthetic work remains to be done for me to consider it fully "[published][]"
(what does this word mean in 2015?).
You can see the full list of to-dos by visiting the [issues page][issues] of the Github site.

Contact me
----------

If you'd like to contact me about the state of this work or my writing in general, you can email me at <case@autocento.me>.

<!-- links & footnotes -->
[of the breakfast table]: http://www.ibiblio.org/eldritch/owh/abt.html
[citation needed]: https://en.wikipedia.org/wiki/Wikipedia:Citing_sources#Dealing_with_unsourced_material

[text]: src/index.html

[pandoc]: http://johnmacfarlane.net/pandoc/
[compile.lua]: https://github.com/duckwork/autocento/blob/gh-pages/compile.lua
[this template]: https://github.com/duckwork/autocento/blob/gh-pages/.template.html
[Github]: https://github.com/
[git]: http://www.git-scm.com/
[my Github profile]: https://github.com/duckwork/autocento

[index]: index.html
[this javascript]: https://github.com/duckwork/autocento/blob/gh-pages/js/lozenge.js

[published]: published.html
[issues]: https://github.com/duckwork/autocento/issues

[^1]: I've decided to use the word _article_ instead of _poem_, because not all of the texts included are poems; and instead of _piece_, because _piece_ is vague and, to my mind, pretentious.
    I'm aware that the true [etymology](http://www.etymonline.com/index.php?search=article) of _article_ does not reflect my use of it, namely "a little chunk of art", a la the (personal folk) derivation of _icicle_, _treicle_, etc.

[^2]: The great thing about `pandoc` is that it can compile to, and convert between, about fifty formats or so.
    This means that if, in the future, I choose to convert this project to a printable form (for example PDF, ODT, or even DOCX), I'll be able to with a fairly small amount of work.

[^3]: For more information on the technological aspect of this project, see the [README.md](https://github.com/duckwork/autocento/blob/gh-pages/README.md) file at the root of the github repo.
