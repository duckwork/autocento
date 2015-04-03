# MAKEFILE for Autocento of the breakfast table
# by Case Duckworth | case.duckworth@gmail.com | autocento.me
# inspired by Lincoln Mullen | lincolnmullen.com
# vim: fdm=marker

# Define variables {{{
srcs      := $(wildcard *.txt)
templates := $(wildcard _template.*)
trunk     := trunk
metas      = hapax first-lines common-titles index
metas     += $(templates)

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

firstLinesTxt    = first-lines.txt
firstLinesOut    = first-lines.html
firstLiner       = $(trunk)/first-lines.sh
firstLinesHead   = $(trunk)/first-lines.head
commonTitlesTxt  = common-titles.txt
commonTitlesOut  = common-titles.html
commonTitler     = $(trunk)/common-titles.sh
commonTitlesHead = $(trunk)/common-titles.head
# }}}

.PHONY: all
all: $(hapaxOut) $(firstLinesOut) $(commonTitlesOut)\
     $(htmlPre) $(htmls) $(lozengeOut)\
     $(backTxts) $(backHtms)

# HTML {{{
$(htmlPre): $(htmlPreSrc)
	ghc --make $(htmlPreSrc)

%.html: %.txt | $(htmlTemplate) $(htmlPre)
	pandoc $< -t html5 $(htmlPandocOptions) -o $@

$(lozengeOut): $(htmls)
	@bash $(lozenger) $(lozengeOut) $(htmls)
# }}}
# BACKLINKS {{{
%.back: %.html | $(backHead)
	@bash $(backlinker) $< $@ $(backHead) $(htmls)

%_backlinks.htm: %.back | $(htmlTemplate)
	pandoc $< -t html5 $(backPandocOptions) -o $@
# }}}
# HAPAX {{{
$(hapaxPre): $(hapaxPreSrc)
	ghc --make $(hapaxPreSrc)

%.hapax: %.txt | $(hapaxPre)
	pandoc $< -t $(hapaxer) $(hapaxPandocOptions) -o $@

$(hapaxOut): $(hapaxs) | $(hapaxPre) $(hapaxLinker) $(hapaxHead)
	pandoc $^ -t $(hapaxer) -o $(hapaxOut)
	@bash $(hapaxLinker) $@ $(hapaxHead) $^
# }}}
# FIRST LINES & COMMON TITLES {{{
$(firstLinesTxt): $(txts) | $(firstLiner) $(firstLinesHead)
	@bash $(firstLiner) $@ $(firstLinesHead) $^

$(firstLinesOut): $(firstLinesTxt) | $(htmlTemplate) $(htmlPre)
	pandoc $< -t html5 $(htmlPandocOptions) -o $@

$(commonTitlesTxt): $(txts) | $(commonTitler) $(commonTitlesHead)
	@bash $(commonTitler) $@ $(commonTitlesHead) $^

$(commonTitlesOut): $(commonTitlesTxt) | $(htmlTemplate) $(htmlPre)
	pandoc $< -t html5 $(htmlPandocOptions) -o $@
# }}}
# CLEAN {{{
.PHONY: clean
clean:
	-rm -f $(hapaxs) $(hapaxOut)
	-rm -f $(firstLinesOut) $(firstLinesTxt)
	-rm -f $(commonTitlesOut) $(commonTitlesTxt)
	-rm -f $(htmls)
	-rm -f $(backHtms)
	-rm -f *.tmp trunk/*.tmp

.PHONY: nuke
nuke: clean
	-rm -f $(hapaxPre) $(htmlPre)

.PHONY: again
again: clean all
# }}}
