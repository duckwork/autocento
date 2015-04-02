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
# }}}

.PHONY: all
all: $(hapaxOut)\
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
	pandoc $< -t html5 $(backPandocOptions) -o $@ && rm $<
# }}}
# HAPAX {{{
$(hapaxPre): $(hapaxPreSrc)
	ghc --make $(hapaxPreSrc)

%.hapax: %.txt | $(hapaxPre)
	pandoc $< -t $(hapaxer) $(hapaxPandocOptions) -o $@

$(hapaxOut): $(hapaxs) | $(hapaxPre) $(hapaxLinker) $(hapaxHead)
	pandoc $^ -t $(hapaxer) -o $(hapaxOut)
	@bash $(hapaxLinker) $@ $(hapaxHead) $^
	-rm *.hapax
# }}}
# FIRST LINES & COMMON TITLES {{{
# TODO
# }}}
# CLEAN {{{
.PHONY: clean
clean:
	-rm -f $(hapaxs) $(hapaxOut)
	-rm -f $(htmls)
	-rm -f $(backHtms)
	-rm -f *.tmp trunk/*.tmp

.PHONY: nuke
nuke: clean
	-rm -f $(hapaxPre) $(htmlPre)

.PHONY: again
again: clean all
# }}}
