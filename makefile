# Produce HTML & RIVER outputs with pandoc
# Case Duckworth | autocento.me
# inspired by Lincoln Mullen | lincolnmullen.com

# Define directories, file lists, and options
TEXTs  := $(wildcard *.txt)

VERSIFYer = trunk/versify.exe

HTMLbl := index.html template.html index-txt.html
HTMLs  := $(filter-out $(HTMLbl),$(patsubst %.txt,%.html,$(TEXTs)))
HTMopts = --template=template.html
HTMopts+= --filter=$(VERSIFYer)
HTMopts+= --smart --mathml --section-divs

BKTXTbl = "hapax.txt|first-lines.txt|common-titles.txt"
BKTXTs  = $(patsubst %.html,%.back,$(HTMLs))
BKTXThd = trunk/backlink.head
BKHTMLs = $(patsubst %.back,%_backlinks.htm,$(BKTXTs))

RIVERbl:= first-lines.river common-titles.river hapax.river
RIVERer = trunk/river.lua
RIVERs := $(filter-out $(RIVERbl),$(patsubst %.txt,%.river,$(TEXTs)))

HAPAXs := $(RIVERs)
HAPAXer = trunk/hapax.lua
HAPAXhd:= trunk/hapax.head
HAPAXtmp= hapax.tmp
HAPAX   = hapax.txt

LOZENGE = trunk/lozenge.js

.PHONY: all
all : river hapax $(VERSIFYer) html lozenge backlinks

.PHONY: hapax
hapax : $(HAPAX)
.PHONY: html
html : $(HTMLs)
.PHONY: river
river : $(RIVERs)
.PHONY: lozenge
lozenge : $(LOZENGE)
.PHONY: backlinks
backlinks : $(BKHTMLs)

%.html : %.txt template.html $(VERSIFYer)
	pandoc $< -f markdown -t html5 $(HTMopts) -o $@

%_backlinks.htm : %.back
	pandoc $< -f markdown -t html5 $(HTMopts) -o $@

%.back : %.txt $(BKTXThd)
	@echo -n "Back-linking $<"
	@cat $(BKTXThd) > $@
	-@grep -ql "$(patsubst %.txt,%.html,$<)" *.txt |\
	  grep -vE $(BKTXTbl) >> $@ || \
	  echo "_Nothing links here!_" >> $@;
	@echo -n "."
	@title=`grep '^title:' $< | cut -d' ' -f2-`; \
	 sed -i "s/_TITLE_/$$title/" $@;
	@echo -n "."
	@for file in `cat $@ | grep '.txt'`; do \
	    title=`grep '^title:' $$file | cut -d' ' -f2-`; \
	    replace=`basename $$file .txt`; \
	    sed -i "s/^\($$replace\).txt$$/- [$$title](\1.html)/" $@;\
	    echo -n "."; \
	 done
	@echo "Done."

%.river : %.txt
	@echo River-ing $@
	@sed -e '/^---$$/,/^...$$/d'\
	     -e "s/[^][A-Za-z0-9\/\"':.-]/ /g" $< |\
	 pandoc - -f markdown -t $(RIVERer) -o $@

$(VERSIFYer) : trunk/versify.hs
	ghc --make trunk/versify.hs

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
	@echo -n "Linking $(HAPAX)"
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
	-rm -f hapax.txt hapax.tmp
	-rm -f $(RIVERs)
	-rm -f $(HTMLs)
	-rm -f $(BKTXTs) $(BKHTMLs)

.PHONY: again
again: clean all
