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

# Do everything
all : $(HTMLs) $(RIVERs)

# Generic rule for HTML targets and Markdown sources
%.html : %.txt
	pandoc $< -f markdown -t html5 $(HTMLopts) -o $(HTMLdir)/$@

# Generic rule for RIVER targets and Markdown sources
%.river : %.txt
	pandoc $< -f markdown -t $(LUAdir)/river.lua $(RIVopts) -o $(RIVdir)/$@
