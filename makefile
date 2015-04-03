# MAKEFILE for Autocento of the breakfast table
# by Case Duckworth | case.duckworth@gmail.com | autocento.me
# inspired by Lincoln Mullen | lincolnmullen.com
# vim: fdm=marker

# Define variables {{{
srcs      := $(wildcard *.txt)
templates := $(wildcard _template.*)
trunk     := trunk
metas      = hapax first-lines common-titles index island
metas     += $(templates) $(wildcard _*)

txts = $(filter-out \
       $(patsubst %,%.txt,$(metas)),\
       $(srcs))

htmls = $(filter-out \
        $(patsubst %,%.html,$(metas)),\
        $(patsubst %.txt,%.html,$(srcs)))
htmlPre           = $(trunk)/versify.exe
htmlPreSrc        = $(trunk)/versify.hs
htmlTemplate      = _template.html
htmlPandocOptions = --template=$(htmlTemplate)
htmlPandocOptions+= --filter=$(htmlPre)
htmlPandocOptions+= --smart --mathml --section-divs

lozenger   = $(trunk)/lozenge.sh
lozengeOut = $(trunk)/lozenge.js

hapaxs = $(filter-out \
         $(patsubst %,%.hapax,$(metas)),\
         $(patsubst %.txt,%.hapax,$(srcs)))
hapaxer            = $(trunk)/hapax.lua
hapaxPre           = $(trunk)/forceascii.exe
hapaxPreSrc        = $(trunk)/forceascii.hs
hapaxPandocOptions = --filter=$(hapaxPre)
hapaxOut           = hapax.txt
hapaxHead          = $(trunk)/hapax.head
hapaxLinker        = $(trunk)/hapaxlink.sh

backTxts   = $(patsubst %.html,%.back,$(htmls))
backHtms   = $(patsubst %.back,%_backlinks.htm,$(backTxts))
backHead   = $(trunk)/backlink.head
backlinker = $(trunk)/backlink.sh
backPandocOptions = --template=$(htmlTemplate) --smart

islandHead = $(trunk)/island.head
islandTxt  = island.txt
islandHtm  = island.htm

firstLinesTxt    = first-lines.txt
firstLinesOut    = first-lines.html
firstLiner       = $(trunk)/first-lines.sh
firstLinesHead   = $(trunk)/first-lines.head
commonTitlesTxt  = common-titles.txt
commonTitlesOut  = common-titles.html
commonTitler     = $(trunk)/common-titles.sh
commonTitlesHead = $(trunk)/common-titles.head
# }}}
# PHONY {{{
.PHONY: all clean nuke again meta
all: meta \
     $(htmlPre) $(htmls) $(lozengeOut)\
     $(backHtms) $(islandHtm)

clean:
	-rm -f $(hapaxs) $(hapaxOut)
	-rm -f $(firstLinesOut) $(firstLinesTxt)
	-rm -f $(commonTitlesOut) $(commonTitlesTxt)
	-rm -f $(htmls)
	-rm -f $(backTxts) $(backHtms)
	-rm -f *.tmp trunk/*.tmp

nuke: clean
	-rm -f $(hapaxPre) $(htmlPre)

again: clean all

meta: $(hapaxOut) $(firstLinesOut) $(commonTitlesOut)
# }}}
# HTML {{{
$(htmlPre): $(htmlPreSrc)
	ghc --make $(htmlPreSrc)

%.html: %.txt $(htmlTemplate) $(htmlPre)
	pandoc $< -t html5 $(htmlPandocOptions) -o $@

$(lozengeOut): $(htmls)
	bash $(lozenger) $(lozengeOut) $(htmls)
# }}}
# BACKLINKS {{{
%.back: %.html $(backHead)
	@bash $(backlinker) $< $@ $(backHead) $(islandHead) $(txts)

%_backlinks.htm: %.back
	pandoc $< -t html5 $(backPandocOptions) -o $@

$(islandTxt): $(backTxts)

$(islandHtm): $(islandTxt) $(islandHead) $(backHtms)
	pandoc $< -t html5 $(htmlPandocOptions) -o $@
	rm -f $(islandTxt)
# }}}
# HAPAX {{{
$(hapaxPre): $(hapaxPreSrc)
	ghc --make $(hapaxPreSrc)

%.hapax: %.txt $(hapaxPre) $(hapaxLinker) $(hapaxHead)
	pandoc $< -t $(hapaxer) $(hapaxPandocOptions) -o $@

$(hapaxOut): $(hapaxs)
	pandoc $^ -t $(hapaxer) -o $@
	bash $(hapaxLinker) $@ $(hapaxHead) $^
# }}}
# FIRST LINES & COMMON TITLES {{{
$(firstLinesTxt): $(txts) | $(firstLiner) $(firstLinesHead)
	bash $(firstLiner) $@ $(firstLinesHead) $^

$(firstLinesOut): $(firstLinesTxt) $(htmlTemplate) $(htmlPre)
	pandoc $< -t html5 $(htmlPandocOptions) -o $@

$(commonTitlesTxt): $(txts) | $(commonTitler) $(commonTitlesHead)
	bash $(commonTitler) $@ $(commonTitlesHead) $^

$(commonTitlesOut): $(commonTitlesTxt) $(htmlTemplate) $(htmlPre)
	pandoc $< -t html5 $(htmlPandocOptions) -o $@
# }}}
