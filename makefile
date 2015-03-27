# Produce HTML & RIVER outputs with pandoc
# Case Duckworth | autocento.me
# inspired by Lincoln Mullen | lincolnmullen.com

# Define directories, file lists, and options
TEXTs  := $(wildcard *.txt)

HTMLbl := index.html template.html index-txt.html
HTMLs  := $(filter-out $(HTMLbl),$(patsubst %.txt,%.html,$(TEXTs)))
HTMopts = --template=template.html
HTMopts+= --smart --mathml --section-divs

HAPAXbl:= first-lines.river common-titles.river hapax.river
RIVERer = trunk/river.lua
RIVERs := $(filter-out $(HAPAXbl),$(patsubst %.txt,%.river,$(TEXTs)))

HAPAXs := $(filter-out $(HAPAXbl),$(RIVERs))
HAPAXer = trunk/hapax.lua
HAPAXhd:= trunk/hapax.head
HAPAXtmp= hapax.tmp
HAPAX   = hapax.txt

LOZENGE = trunk/lozenge.js

.PHONY: all
all     : hapax html river lozenge

.PHONY: hapax
hapax   : $(HAPAX)
.PHONY: html
html    : $(HTMLs)
.PHONY: river
river   : $(RIVERs)
.PHONY: lozenge
lozenge : $(LOZENGE)

# Generic rule for HTML targets and Markdown sources
%.html : %.txt template.html
	pandoc $< -f markdown -t html5 $(HTMopts) -o $@

# Generic rule for RIVER targets and Markdown sources
%.river : %.txt
	@echo River-ing $@
	@sed -e '/^---$$/,/^...$$/d'\
	     -e "s/[^][A-Za-z0-9\/\"':.-]/ /g" $< |\
	 pandoc - -f markdown -t $(RIVERer) -o $@

$(LOZENGE) : $(HTMLs)
	@echo "Updating lozenge.js..."
	@list=`echo $(HTMLs) |\
	 sed -e 's/\(\S\+.html\) \?/"\1",/g'\
	     -e 's/^\(.*\),$$/var files=[\1]/'` &&\
	 sed -i "s/var files=.*/$$list/" $(LOZENGE)

$(HAPAX) : $(RIVERs) $(HAPAXhd)
	-rm -f $(HAPAXbl)
	@echo "Compiling $(HAPAX)..."
	pandoc -f markdown -t $(HAPAXer) -o $(HAPAX) *.river
	@echo -n "Linking $(HAPAX)..."
	@cat $(HAPAXhd) > $(HAPAXtmp) &&\
	 for word in `sort hapax.txt`; do\
	    file=`grep -liwq "^$$word$$" *.river | grep -v '$(HAPAX)'`;\
	    echo "[$$word](`basename $$file river`html)">>$(HAPAXtmp);\
	    echo -n '.';\
	 done && mv $(HAPAXtmp) $(HAPAX)
	@echo "Done."

# TODO: Add indices compilers (first-lines, common-titles)

.PHONY: clean
clean:
	-rm -f hapax.txt hapax.tmp *.river
	-rm -f $(HTMLs)

.PHONY: again
again: clean all
