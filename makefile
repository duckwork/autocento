# Makefile for Autocento of the breakfast table
# by Case Duckworth | autocento.me
# vim: fdm=marker

# variables {{{
appendixd    := appendix
backlinkd    := backlinks
frontmatterd := front-matter
hapaxd       := hapax
scriptd      := scripts
templated    := templates
textd        := text
trunkd       := trunk
wipd         := wip

compiler := bash $(scriptd)/compile.sh
texts    := $(wildcard $(textd)/*.txt)
frontmatter := $(wildcard $(frontmatterd)/*.txt)

htmls          = $(patsubst $(textd)/%.txt,%.html,$(texts)) \
		 $(patsubst $(frontmatterd)/%.txt,%.html,$(frontmatter))
htmlWriter    := html5
htmlTemplate  := $(templated)/page.html
htmlFilter    := $(scriptd)/versify.exe
htmlFilterSrc := $(scriptd)/versify.hs      # Converts <br />s to <span>s
htmlOptions   := --template=$(htmlTemplate)
htmlOptions   += --filter=$(htmlFilter)
htmlOptions   += --smart        # Smart "correct" typeography
htmlOptions   += --mathml       # Use mathml for TeX math in HTML
htmlOptions   += --section-divs # Add a <section> around sections
htmlOptions   += --normalize    # merge adjacent `Str`, `Emph`, `Space`

randomize := $(scriptd)/randomize.js

backTexts         = $(patsubst $(textd)/%.txt,$(backlinkd)/%.back,$(texts))
backTextHead     := $(trunkd)/backlink.head
backHtmls        := $(patsubst %.back,%.html,$(backTexts))
backHtmlWriter   := $(htmlWriter)
backHtmlTemplate := $(templated)/backlinks.html
backHtmlOptions  := --template=$(backHtmlTemplate)
backHtmlOptions  += --smart

hapaxSrcs       = $(patsubst $(textd)/%.txt,$(hapaxd)/%.hapax,$(texts))
hapax          := $(appendixd)/hapax.txt
hapaxWriter    := $(scriptd)/hapax.lua
hapaxFilter    := $(scriptd)/forceascii.exe
hapaxFilterSrc := $(scriptd)/forceascii.hs
hapaxOptions   := --filter=$(hapaxFilter)
hapaxHead      := $(trunkd)/hapax.head
hapaxTmp       := $(trunkd)/_HAPAXTMP.tmp
hapaxHtml      := hapax.html

island           := $(appendixd)/islands.txt
islandHead       := $(trunkd)/islands.head
islandHtml       := islands.html
firstLines       := $(appendixd)/first-lines.txt
firstLinesHead   := $(trunkd)/first-lines.head
firstLinesHtml   := first-lines.html
commonTitles     := $(appendixd)/common-titles.txt
commonTitlesHead := $(trunkd)/common-titles.head
commonTitlesHtml := common-titles.html
toc              := $(appendixd)/toc.txt
tocHead          := $(trunkd)/toc.head
tocHtml          := toc.html
appendices       := $(firstLines) $(commonTitles) $(toc) $(hapax)
appendixHtmls    := $(patsubst $(appendixd)/%.txt,%.html,$(appendices))
# }}}
# PHONY TARGETS {{{
.PHONY: all clean again appendices htmls backlinks
all : appendices backlinks htmls
htmls: $(htmls)
backlinks: $(backHtmls) $(islandHtml)
appendices: $(appendixHtmls)
clean :
	-rm -f $(htmls)
	-rm -f $(backlinkd)/*
	-rm -f $(appendixd)/*
	-rm -f $(hapaxd)/*
	-rm -f $(appendixHtmls)
again : clean all
# }}}
# HTMLS {{{
%.html : $(textd)/%.txt $(htmlFilter) $(htmlTemplate)
	pandoc $< -t $(htmlWriter) $(htmlOptions) -o $@

%.html : $(frontmatterd)/%.txt
	pandoc $< -t $(htmlWriter) $(htmlOptions) -o $@

$(htmlFilter) : $(htmlFilterSrc)
	ghc --make $<
# }}}
# RANDOMIZE.JS {{{
$(randomize) : $(htmls)
	@echo "Updating $@..."
	@$(compiler) $@ $^
# }}}
# BACKLINKS {{{
$(backlinkd)/%.back : $(textd)/%.txt $(backTextHead)
	cat $(backTextHead) > $@
	$(compiler) $@ $< >> $@
	$(compiler) --fix-head $@ $<

$(backlinkd)/%.html : $(backlinkd)/%.back $(backHtmlTemplate)
	pandoc $< -t $(backHtmlWriter) $(backHtmlOptions) -o $@
# }}}
# APPENDICES {{{
$(island) : $(backTexts)
	cat $(islandHead) > $@
	@echo "Compiling $@..."
	@$(compiler) $@ $^ >> $@

$(islandHtml) : $(island)
	pandoc $< -t $(htmlWriter) $(htmlOptions) -o $@

$(firstLines) : $(texts)
	cat $(firstLinesHead) > $@
	@echo "Compiling $@..."
	@$(compiler) $@ $^ >> $@

$(firstLinesHtml) : $(firstLines)
	pandoc $< -t $(htmlWriter) $(htmlOptions) -o $@

$(commonTitles) : $(texts)
	cat $(commonTitlesHead) > $@
	@echo "Compiling $@..."
	@$(compiler) $@ $^ >> $@

$(commonTitlesHtml) : $(commonTitles)
	pandoc $< -t $(htmlWriter) $(htmlOptions) -o $@

$(toc) : $(texts)
	cat $(tocHead) > $@
	@echo "Compiling $@..."
	@$(compiler) $@ $^ >> $@

$(tocHtml) : $(toc)
	pandoc $< -t $(htmlWriter) $(htmlOptions) -o $@
# }}}
# HAPAX LEGOMENA {{{
$(hapaxd)/%.hapax : $(textd)/%.txt $(hapaxWriter)
	pandoc $< -t $(hapaxWriter) $(hapaxOptions) -o $@

$(hapaxFilter) : $(hapaxFilterSrc)
	ghc --make $<

$(hapax) : $(hapaxSrcs)
	pandoc $^ -t $(hapaxWriter) $(hapaxOptions) -o $@
	cat $(hapaxHead) > $(hapaxTmp)
	@echo "Linking $@..."
	@$(compiler) $@ $^ >> $(hapaxTmp)
	mv $(hapaxTmp) $@

$(hapaxHtml) : $(hapax)
	pandoc $< -t $(htmlWriter) $(htmlOptions) -o $@
# }}}
