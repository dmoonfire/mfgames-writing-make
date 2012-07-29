# -*- makefile -*-

#
# Configuration
#

# Include the optional configuration file, which is searched via the
# vpath.
-include v3-vars.make

# The "?=" is used to set it if the including makefile does not or if
# the v3-vars.make doesn't set it or doesn't exist.

# Directories
STYLE_DIR  ?= style
SOURCE_DIR ?= .
BUILD_DIR  ?= build
TEMP_DIR   ?= /tmp/style-make

# Styles
ODT_STYLE  ?= plain
PDF_STYLE  ?= plain

# Controls
.ONESHELL:

#
# Top-Level Rules
#

all:

clean:
	rm -fr $(BUILD_DIR)
	rm -f *~ *.fo

#
# Creole
#

$(TEMP_DIR)/%.xml: $(SOURCE_DIR)/%.txt
	mkdir -p $(TEMP_DIR)/$(dir $*)

	mfgames-creole docbook --ignore-localwords --parse-attributions --parse-backticks --parse-languages --parse-metadata --parse-special-paragraphs --parse-summaries --enable-comments --parse-epigraphs --convert-quotes=docbook --force --output $(TEMP_DIR)/$*.xml $(SOURCE_DIR)/$*.txt

#
# XML
#

$(TEMP_DIR)/%.xml: $(SOURCE_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$(dir $*)

	cp $(SOURCE_DIR)/$*.xml $(TEMP_DIR)/$*.xml

$(BUILD_DIR)/%.xml: xi=$(shell mfgames-docbook xinclude $(TEMP_DIR)/$*.xml)
$(BUILD_DIR)/%.xml: xi2=$(addprefix $(TEMP_DIR)/$(dir $*), $(xi))
$(BUILD_DIR)/%.xml: $(TEMP_DIR)/%.xml 
	$(MAKE) $(xi2)

	mfgames-docbook gather --force $(TEMP_DIR)/$*.xml $(TEMP_DIR)/$*-gather

	mkdir -p $(BUILD_DIR)/$(dir $*)
	cp $(TEMP_DIR)/$*-gather/$(notdir $*).xml $(BUILD_DIR)/$(dir $*)

$(BUILD_DIR)/%.xml: $(BUILD_DIR)/%/index.xml
	cp $(BUILD_DIR)/$*/index.xml $(BUILD_DIR)/$*.xml

#
# ODT
#

$(BUILD_DIR)/%.odt: base=$(subst .xml,,$*)
$(BUILD_DIR)/%.odt: $(BUILD_DIR)/%.xml
	docbook2odf $(BUILD_DIR)/$*.xml --xsl-file=$(STYLE_DIR)/odt/$(ODT_STYLE) --params quote.fancy=1 -f -o $(TEMP_DIR)/$*.odt

	zip -d $(TEMP_DIR)/$*.odt styles.xml
	zip -u -j $(TEMP_DIR)/$*.odt $(STYLE_DIR)/odt/$(ODT_STYLE)/styles.xml

	cp $(TEMP_DIR)/$*.odt $(BUILD_DIR)/$*.odt

#
# RTF
#

$(BUILD_DIR)/%.rtf: $(BUILD_DIR)/%.odt
	unoconv -f rtf $(BUILD_DIR)/$*.odt

#
# PDF
#

$(TEMP_DIR)/%.tex: $(BUILD_DIR)/%.xml
	saxonb-xslt -xsl:$(STYLE_DIR)/tex/$(PDF_STYLE).xsl -s:$(BUILD_DIR)/$*.xml -o:$(TEMP_DIR)/$*.tex

	# Convert the -FIRSTPARA- lines into drop capitals using lettrine.
	perl -n -e \
		's/-FIRSTPARA-\s*(.)([^\s]*)/\\lettrine{$$1}{$$2}/sg;print' \
		< $(TEMP_DIR)/$*.tex > $(TEMP_DIR)/$(dir $*)/styled.tex
	mv $(TEMP_DIR)/$(dir $*)/styled.tex $(TEMP_DIR)/$*.tex

$(TEMP_DIR)/%.pdf: $(TEMP_DIR)/%.tex
	xelatex -output-directory=$(TEMP_DIR)/$(dir $*) $(TEMP_DIR)/$*.tex
	xelatex -output-directory=$(TEMP_DIR)/$(dir $*) $(TEMP_DIR)/$*.tex
	xelatex -output-directory=$(TEMP_DIR)/$(dir $*) $(TEMP_DIR)/$*.tex

$(BUILD_DIR)/%.pdf: $(TEMP_DIR)/%.pdf
	cp $(TEMP_DIR)/$*.pdf $(BUILD_DIR)/$*.pdf