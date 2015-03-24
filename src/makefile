# Produce HTML & RIVER outputs with pandoc
# Case Duckworth | autocento.me
# inspired by Lincoln Mullen | lincolnmullen.com

# Define directories, file lists, and options
HTMLdir = ..
RIVdir  = ../river
LUAdir  = ../lua
HTMLs  := $(patsubst %.txt,%.html,$(wildcard *.txt))
HTMopts = --template=$(HTMLdir)/.template.html
HTMopts+= --smart --mathml --section-divs
RIVERs := $(patsubst %.txt,%.river,$(wildcard *.txt))
RIVopts =
LOZENGE = ../js/lozenge.js
LOZupd  = ../js/update-lozenge.sh

# Do everything
.PHONY: all
all : $(HTMLs) $(RIVERs) lozenge

# Generic rule for HTML targets and Markdown sources
%.html : %.txt
	pandoc $< -f markdown -t html5 $(HTMopts) -o $(HTMLdir)/$@

# Generic rule for RIVER targets and Markdown sources
%.river : %.txt
	pandoc $< -f markdown -t $(LUAdir)/river.lua $(RIVopts) -o $(RIVdir)/$@

lozenge : $(HTMLdir)/$(HTMLs)
	@echo "Updating lozenge.js..."
	@list=`ls $(HTMLdir)/*.html |\
	sed -e 's,../,,g' |\
	tr '\n' ' ' |\
	sed -e 's/\(\S\+.html\) /"\1",/g'\
	    -e 's/^\(.*\),$$/var files=[\1]/'` &&\
	sed -i "s/var files=.*/$$list/" $(LOZENGE)
# TODO: add compiling hapax
