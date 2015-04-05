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
backHtmTemplate = _backlinks_template.htm
backPandocOptions = --template=$(backHtmTemplate) --smart

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

tocTxt  = _toc.txt
tocHtml = _toc.html
tocer   = $(trunk)/toc.sh
tocHead = $(trunk)/toc.head
tocInc = $(hapaxOut) $(islandTxt) $(firstLinesTxt) $(commonTitlesTxt) $(txts)
# }}}
# PHONY {{{
.PHONY: all clean distclean again remake meta
all: meta \
     $(htmlPre) $(htmls) $(lozengeOut)\
     $(backHtms) $(islandHtm)

clean:
	-rm -f $(hapaxs)
	-rm -f $(firstLinesTxt)
	-rm -f $(commonTitlesTxt)
	-rm -f $(backTxts)
	-rm -f *.tmp trunk/*.tmp

distclean: clean
	-rm -f $(hapaxPre) $(htmlPre) hapax.html
	-rm -f $(hapaxOut) $(firstLinesOut) $(commonTitlesOut)
	-rm -f $(backHtms)
	-rm -f $(htmls)

again: clean all
remake: distclean all

meta: $(hapaxOut) $(firstLinesOut) $(commonTitlesOut) $(tocHtml)
# }}}
# HTML {{{
$(htmlPre): $(htmlPreSrc)
	ghc --make $(htmlPreSrc)

%.html: %.txt | $(htmlTemplate) $(htmlPre)
	pandoc $< -t html5 $(htmlPandocOptions) -o $@

$(lozengeOut): $(htmls)
	bash $(lozenger) $(lozengeOut) $(htmls)
# }}}
# BACKLINKS {{{
%.back: %.html $(backHead)
	@bash $(backlinker) $< $@ $(backHead) $(txts)

%_backlinks.htm: %.back $(backHtmTemplate)
	pandoc $< -t html5 $(backPandocOptions) -o $@

$(islandTxt): $(backTxts)

$(islandHtm): $(islandTxt) $(islandHead) $(backHtms)
	pandoc $(islandHead) $< -t html5 $(htmlPandocOptions) -o $@

$(tocTxt): $(tocInc) | $(tocead) $(tocer)
	@bash $(tocer) $(tocTxt) $(tocInc)

$(tocHtml): $(tocTxt) $(tocHead)
	pandoc $(tocHead) $< -t html5 $(htmlPandocOptions) -o $@
# }}}
# HAPAX {{{
$(hapaxPre): $(hapaxPreSrc)
	ghc --make $(hapaxPreSrc)

%.hapax: %.txt $(hapaxPre) $(hapaxLinker)
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
