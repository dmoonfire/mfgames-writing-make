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
STYLE_DIR   ?= style
SOURCE_DIR  ?= .
BUILD_DIR   ?= build
TEMP_DIR    ?= build/tmp

# Styles
EPUB_STYLE  ?= plain
ODT_STYLE   ?= plain
PDF_STYLE   ?= plain
COVER_STYLE ?= plain

#
# Top-Level Rules
#

all:

clean:
	rm -fr $(BUILD_DIR) $(TEMP_DIR)
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

	# Escape the generated LaTeX.
	cat $(TEMP_DIR)/$*.tex | \
		sed 's@\$$@\\$$@g' | \
		sed 's@&@\\&@g' | \
		sed 's@\^@\\^@g' > $(TEMP_DIR)/$(dir $*)/styled.tex
	mv $(TEMP_DIR)/$(dir $*)/styled.tex $(TEMP_DIR)/$*.tex

	# Convert the -FIRSTPARA- lines into drop capitals using lettrine.
	perl -n -e \
		's/-FIRSTPARA-\s*(.)([^\s]*)/\\lettrine{$$1}{$$2}/sg;print' \
		< $(TEMP_DIR)/$*.tex > $(TEMP_DIR)/$(dir $*)/styled.tex
	mv $(TEMP_DIR)/$(dir $*)/styled.tex $(TEMP_DIR)/$*.tex

	# Copy any additional assets from the source file.
	if [ -d $(STYLE_DIR)/tex/$(PDF_STYLE) ]; \
	then \
		cp $(STYLE_DIR)/tex/$(PDF_STYLE)/* $(TEMP_DIR)/$(dir $*); \
	fi

$(TEMP_DIR)/%.pdf: $(TEMP_DIR)/%.tex
	cd $(TEMP_DIR)/$(dir $*) && \
		xelatex -halt-on-error $(notdir $*).tex > /dev/null
	cd $(TEMP_DIR)/$(dir $*) && \
		xelatex -halt-on-error $(notdir $*).tex > /dev/null
	cd $(TEMP_DIR)/$(dir $*) && \
		xelatex -halt-on-error $(notdir $*).tex > /dev/null

$(BUILD_DIR)/%.pdf: $(TEMP_DIR)/%.pdf
	cp $(TEMP_DIR)/$*.pdf $(BUILD_DIR)/$*.pdf

#
# EPUB
#

$(TEMP_DIR)/%-epub/content.html: $(STYLE_DIR)/epub/$(EPUB_STYLE)/content.xsl $(BUILD_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/content.xsl \
		-s:$(BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/content.html

$(TEMP_DIR)/%-epub/toc.html: $(STYLE_DIR)/epub/$(EPUB_STYLE)/toc.xsl $(BUILD_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/toc.xsl \
		-s:$(BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/toc.html

$(TEMP_DIR)/%-epub/cover.html: $(STYLE_DIR)/epub/$(EPUB_STYLE)/cover.xsl $(BUILD_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/cover.xsl \
		-s:$(BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/cover.html

$(TEMP_DIR)/%-epub/toc.ncx: $(STYLE_DIR)/epub/$(EPUB_STYLE)/ncx.xsl $(BUILD_DIR)/%.xml
	# Create the NCX file which has placeholders for the sequence.
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/ncx.xsl \
		-s:$(BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/toc.ncx

	# Reformat the NCX file so everything is in proper order and
	# sequential.
	mfgames-ncx format $(TEMP_DIR)/$*-epub/toc.ncx

$(TEMP_DIR)/%-epub/content.opf: $(STYLE_DIR)/epub/$(EPUB_STYLE)/opf.xsl $(BUILD_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/opf.xsl \
		-s:$(BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/content.opf

$(BUILD_DIR)/%.jpg: $(SOURCE_DIR)/%.jpg
	mkdir -p $(BUILD_DIR)/$(dir $*)
	cp $(SOURCE_DIR)/$*.jpg $(BUILD_DIR)/$*.jpg

$(BUILD_DIR)/%.jpg: $(BUILD_DIR)/%.xml $(STYLE_DIR)/cover/$(COVER_STYLE).xsl
	# We have to create a cover using `fop`.
	mkdir -p $(TEMP_DIR)/$*-cover
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/cover/$(COVER_STYLE).xsl \
		-s:$(BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-cover/cover.fop

	# Create the PNG version of the cover.
	fop $(TEMP_DIR)/$*-cover/cover.fop -png $(TEMP_DIR)/$*-cover/cover.png

	# Convert the PNG to JPG.
	convert $(TEMP_DIR)/$*-cover/cover.png $(BUILD_DIR)/$*.jpg

$(TEMP_DIR)/%-epub/cover.jpg: $(BUILD_DIR)/%.jpg
	mkdir -p $(TEMP_DIR)/$*-epub
	cp $(BUILD_DIR)/%.jpg $(TEMP_DIR)/%-epub/cover.jpg

	# If the cover exists, we want to use it directly.
	if [ -f $(SOURCE_DIR)/$(dir $*)/cover.jpg ];then \
		cp $(SOURCE_DIR)/$(dir $*)/cover.jpg $(TEMP_DIR)/$*-epub/cover.jpg; \
	fi

	# If the cover doesn't exist, we want to make one.

$(TEMP_DIR)/%.epub: $(BUILD_DIR)/%.xml $(TEMP_DIR)/%-epub/content.html $(TEMP_DIR)/%-epub/toc.html $(TEMP_DIR)/%-epub/toc.ncx $(TEMP_DIR)/%-epub/content.opf $(TEMP_DIR)/%-epub/cover.html $(TEMP_DIR)/%-epub/cover.jpg
	# Remove any existing epub file, because we have to rebuild it.
	rm -f $(BUILD_DIR)/$*.epub

	# Create the mimetype file.
	echo -n "application/epub+zip" > $(TEMP_DIR)/$*-epub/mimetype

	# Create the META-INF directory.
	mkdir $(TEMP_DIR)/$*-epub/META-INF
	echo '<?xml version="1.0"?>' > $(TEMP_DIR)/$*-epub/META-INF/container.xml
	echo '<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">' >> $(TEMP_DIR)/$*-epub/META-INF/container.xml
	echo '   <rootfiles>' >> $(TEMP_DIR)/$*-epub/META-INF/container.xml
	echo '      <rootfile full-path="content.opf" media-type="application/oebps-package+xml"/>' >> $(TEMP_DIR)/$*-epub/META-INF/container.xml
	echo '   </rootfiles>' >> $(TEMP_DIR)/$*-epub/META-INF/container.xml
	echo '</container>' >> $(TEMP_DIR)/$*-epub/META-INF/container.xml

	# Zip all the contents of the file
	cd $(TEMP_DIR)/$*-epub && zip -X0 epub.zip mimetype
	cd $(TEMP_DIR)/$*-epub && zip -rDX9 epub.zip * -x mimetype -x epub.zip
	mv $(TEMP_DIR)/$*-epub/epub.zip $(TEMP_DIR)/$*.epub

	# Verify that we have a valid epub file.
	epubcheck $(TEMP_DIR)/$*.epub

$(BUILD_DIR)/%.epub: $(TEMP_DIR)/%.epub
	cp $(TEMP_DIR)/$*.epub $(BUILD_DIR)/$*.epub