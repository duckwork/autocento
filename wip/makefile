# MAKEFILE for Autocento of the breakfast table
# by Case Duckworth | case.duckworth@gmail.com | autocento.me
# inspired by Lincoln Mullen | lincolnmullen.com
# vim: fdm=marker

# Define variables {{{
srcs := $(wildcard *.txt)
trunk:= trunk
versifyer = $(trunk)/versify.exe
versifySrc= $(trunk)/versify.hs

htmlBlackList = index.html template.html index-txt.html
htmls = $(filter-out $(htmlBlackList),$(patsubst %.txt,%.html,$(srcs)))
htmlTemplate = template.html
htmlPandocOptions = --template=$(htmlTemplate)
htmlPandocOptions+= --filter=$(versifyer)
htmlPandocOptions+= --smart --mathml --section-divs

backBlackList = "hapax.txt|first-lines.txt|common-titles.txt"
backSrcs = $(patsubst %.html,%.back,$(htmls))
backs = $(patsubst %.back, %_backlinks.htm,$(backSrcs))
backHead = $(trunk)/backlink.head

hapaxBlackList = first-lines.txt common-titles.txt hapax.txt
hapaxs = $(patsubst %.txt,%.hapax,$(srcs))
hapaxer = $(trunk)/hapax.lua
hapaxHead = $(trunk)/hapax.head
hapaxTemp = hapax.tmp
hapaxOut = hapax.txt

lozengeOut = $(trunk)/lozenge.js
# }}}

.PHONY: all
all: $(versifyer) htmls backlinks
.PHONY: htmls
htmls: $(htmls)
.PHONY: backlinks
backlinks: $(backs)

$(versifyer): $(versifySrc)
	ghc --make $(versifySrc)

%.html: %.txt template.html $(versifyer)
	pandoc $< -f markdown -t html5 $(htmlPandocOptions) -o $@

%_backlinks.htm: %.back
	pandoc $< -f markdown -t html5 $(htmlPandocOptions) -o $@
