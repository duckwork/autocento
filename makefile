# Produce HTML & RIVER outputs with pandoc
# Case Duckworth | autocento.me
# inspired by Lincoln Mullen | lincolnmullen.com

# Define directories, file lists, and options
HTMLs  := $(patsubst %.txt,%.html,$(wildcard *.txt))
HTMopts = --template=.template.html
HTMopts+= --smart --mathml --section-divs
RIVERer = lua/river.lua
RIVERs := $(patsubst %.txt,%.river,$(wildcard *.txt))
RIVopts =
LOZENGE = js/lozenge.js

# Do everything
.PHONY: all html river lozenge
all     : html river lozenge
html    : $(HTMLs)
river   : $(RIVERs)
lozenge : $(LOZENGE)

# Generic rule for HTML targets and Markdown sources
%.html : %.txt
	pandoc $< -f markdown -t html5 $(HTMopts) -o $@

# Generic rule for RIVER targets and Markdown sources
%.river : %.txt
	@echo River-ing $@
	@sed -e '/^---$$/,/^...$$/d'\
	     -e "s/[^][A-Za-z0-9\/\"':.-]/ /g" $< |\
	pandoc - -f markdown -t $(RIVERer) $(RIVopts) -o $@

$(LOZENGE) : $(HTMLs)
	@echo "Updating lozenge.js..."
	@list=`ls *.html |\
	sed -e 's,../,,g' |\
	tr '\n' ' ' |\
	sed -e 's/\(\S\+.html\) /"\1",/g'\
	    -e 's/^\(.*\),$$/var files=[\1]/'` &&\
	sed -i "s/var files=.*/$$list/" $(LOZENGE)
# TODO: add compiling hapax
# TODO: add first line compiler
