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
STYLE_DIR     ?= style
SOURCE_DIR    ?= .
BUILD_DIR     ?= build
XML_BUILD_DIR ?= $(BUILD_DIR)
PDF_BUILD_DIR ?= $(BUILD_DIR)
ODT_BUILD_DIR ?= $(BUILD_DIR)
RTF_BUILD_DIR ?= $(ODT_BUILD_DIR)
DOC_BUILD_DIR ?= $(ODT_BUILD_DIR)
DOCX_BUILD_DIR ?= $(ODT_BUILD_DIR)
EPUB_BUILD_DIR ?= $(BUILD_DIR)
MOBI_BUILD_DIR ?= $(EPUB_BUILD_DIR)
JPG_BUILD_DIR ?= $(BUILD_DIR)
HTML_BUILD_DIR ?= $(BUILD_DIR)
TEMP_DIR      ?= build/tmp

# Programs
KINDLEGEN   = /opt/kindlegen/kindlegen
XELATEX     ?= xelatex

# Styles
COVER_STYLE ?= plain
EPUB_STYLE  ?= plain
HTML_STYLE  ?= plain
ODT_STYLE   ?= plain
PDF_STYLE   ?= plain

# Parameters
CREOLE2DOCBOOK_PARAMS ?= --ignore-localwords --parse-attributions --parse-backticks --parse-languages --parse-metadata --parse-special-paragraphs --parse-summaries --enable-comments --parse-epigraphs --convert-quotes=docbook

#
# Top-Level Rules
#

all:

clean:
	rm -fr $(PDF_BUILD_DIR) $(XML_BUILD_DIR) $(BUILD_DIR) $(TEMP_DIR)
	rm -f *~ *.fo

#
# Creole
#

$(TEMP_DIR)/%.xml: $(SOURCE_DIR)/%.txt
	mkdir -p $(TEMP_DIR)/$(dir $*)

	mfgames-creole docbook $(CREOLE2DOCBOOK_PARAMS) --id=$(notdir $*) --force --output $(TEMP_DIR)/$*.xml $(SOURCE_DIR)/$*.txt

	xmllint $(TEMP_DIR)/$*.xml > /dev/null

#
# XML
#

$(TEMP_DIR)/%.xml: $(SOURCE_DIR)/%.xml
	# Even if we don't have it, we want to make sure we have the files needed.
	mkdir -p $(TEMP_DIR)/$(dir $*)

	# Copy the file into the teporary locatino.
	cp $(SOURCE_DIR)/$*.xml $(TEMP_DIR)/$*.xml

	# Make all the dependencies on this file first into the TEMP_DIR.
	$(MAKE) $(addprefix $(TEMP_DIR)/$(dir $*), $(shell mfgames-docbook depends -i $(SOURCE_DIR)/$*.xml))

	# Combine all the XML into a single one. We don't process cover
	# since we'll be manually converting that file into cover.jpg.
	mfgames-docbook gather --copy-media --force \
		--exclude-media=cover.jpg \
		$(TEMP_DIR)/$*.xml $(TEMP_DIR)/$*-gather \
		--directory-root=$(TEMP_DIR) \
		--media-destination=$(TEMP_DIR)/$(dir $*) \
		--media-search $(TEMP_DIR) $(SOURCE_DIR)

	# Put it back in place of the file.
	mv $(TEMP_DIR)/$*-gather/$(notdir $*).xml $(TEMP_DIR)/$*.xml

	# Remove the gather directory.
	rm -rf $(TEMP_DIR)/$*-gather

$(TEMP_DIR)/%.xml: $(TEMP_DIR)/%/index.xml
	cp $(TEMP_DIR)/$*/index.xml $(TEMP_DIR)/$*.xml

$(XML_BUILD_DIR)/%.xml: $(TEMP_DIR)/%.xml 
	mkdir -p $(XML_BUILD_DIR)/$(dir $*)
	cp $(TEMP_DIR)/$*.xml $(XML_BUILD_DIR)/$*.xml

#
# ODT
#

$(STYLE_DIR)/odt/$(ODT_STYLE)/styles.xml: $(STYLE_DIR)/odt/$(ODT_STYLE)/styles.odt
	unzip -p $(STYLE_DIR)/odt/$(ODT_STYLE)/styles.odt styles.xml \
		> $(STYLE_DIR)/odt/$(ODT_STYLE)/styles.xml

$(ODT_BUILD_DIR)/%.odt: $(XML_BUILD_DIR)/%.xml $(STYLE_DIR)/odt/$(ODT_STYLE)/styles.xml
	cd $(XML_BUILD_DIR)/$(dir $*) && docbook2odf $(notdir $*).xml --xsl-file=$(STYLE_DIR)/odt/$(ODT_STYLE) --params quote.fancy=1 -f -o $(notdir $*).odt

	zip -d $(XML_BUILD_DIR)/$*.odt styles.xml
	zip -u -j $(XML_BUILD_DIR)/$*.odt $(STYLE_DIR)/odt/$(ODT_STYLE)/styles.xml

	mkdir -p $(ODT_BUILD_DIR)/$(dir $*)
	-mv $(XML_BUILD_DIR)/$*.odt $(ODT_BUILD_DIR)/$*.odt

#
# RTF
#

$(RTF_BUILD_DIR)/%.rtf: $(ODT_BUILD_DIR)/%.odt
	unoconv -f rtf $(ODT_BUILD_DIR)/$*.odt
	mkdir -p $(RTF_BUILD_DIR)/$(dir $*)
	mv $(ODT_BUILD_DIR)/$*.rtf $(RTF_BUILD_DIR)/$*.rtf

#
# DOC
#

$(DOC_BUILD_DIR)/%.doc: $(ODT_BUILD_DIR)/%.odt
	unoconv -f doc $(ODT_BUILD_DIR)/$*.odt
	mkdir -p $(DOC_BUILD_DIR)/$(dir $*)
	mv $(ODT_BUILD_DIR)/$*.odt $(DOC_BUILD_DIR)/$*.rtf

#
# DOCX
#

$(DOCX_BUILD_DIR)/%.docx: $(ODT_BUILD_DIR)/%.odt
	unoconv -f doc $(ODT_BUILD_DIR)/$*.odt
	mkdir -p $(DOCX_BUILD_DIR)/$(dir $*)
	mv $(ODT_BUILD_DIR)/$*.odt $(DOCX_BUILD_DIR)/$*.rtf

#
# PDF
#

$(TEMP_DIR)/%.tex: $(XML_BUILD_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$(dir $*)

	saxonb-xslt -xsl:$(STYLE_DIR)/tex/$(PDF_STYLE).xsl -s:$(XML_BUILD_DIR)/$*.xml -o:$(TEMP_DIR)/$*.tex

	# Escape the generated LaTeX.
#		sed 's@#@\\#@g' |
	cat $(TEMP_DIR)/$*.tex | \
		sed 's@&@\\&@g' | \
		sed 's@\$$@\\$$@g' | \
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
		$(XELATEX) -halt-on-error $(notdir $*).tex
	cd $(TEMP_DIR)/$(dir $*) && \
		$(XELATEX) -halt-on-error $(notdir $*).tex > /dev/null
	cd $(TEMP_DIR)/$(dir $*) && \
		$(XELATEX) -halt-on-error $(notdir $*).tex > /dev/null

$(PDF_BUILD_DIR)/%.pdf: $(TEMP_DIR)/%.pdf
	mkdir -p $(PDF_BUILD_DIR)/$(dir $*)
	cp $(TEMP_DIR)/$*.pdf $(PDF_BUILD_DIR)/$*.pdf

#
# EPUB
#

$(TEMP_DIR)/%-epub/content.html: $(STYLE_DIR)/epub/$(EPUB_STYLE)/content.xsl $(XML_BUILD_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/content.xsl \
		-s:$(XML_BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/content.html

$(TEMP_DIR)/%-epub/toc.html: $(STYLE_DIR)/epub/$(EPUB_STYLE)/toc.xsl $(XML_BUILD_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/toc.xsl \
		-s:$(XML_BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/toc.html

$(TEMP_DIR)/%-epub/cover.html: $(STYLE_DIR)/epub/$(EPUB_STYLE)/cover.xsl $(XML_BUILD_DIR)/%.xml
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/cover.xsl \
		-s:$(XML_BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/cover.html

$(TEMP_DIR)/%-epub/content.opf: $(STYLE_DIR)/epub/$(EPUB_STYLE)/opf.xsl $(XML_BUILD_DIR)/%.xml
	# Create the content OPF file using stylesheet.
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/opf.xsl \
		-s:$(XML_BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/content.opf

	# Ensure that the OPF file has a unique identifier.
	mfgames-opf uid-generate $(TEMP_DIR)/$*-epub/content.opf

	# Add in the various references.
	for file in $(shell mfgames-docbook depends $(XML_BUILD_DIR)/$*.xml | grep -v cover.jpg);do if [ ! -f $(TEMP_DIR)/$*-epub/$$file ];then cp $(SOURCE_DIR)/$(dir $*)/$$file $(TEMP_DIR)/$*-epub/$$file;fi;mfgames-opf manifest-set $(TEMP_DIR)/$*-epub/content.opf $$file $$file $$(echo "mimetype -b $(TEMP_DIR)/$*-epub/$$file" | xargs mimetype -b);done


$(TEMP_DIR)/%-epub/toc.ncx: $(STYLE_DIR)/epub/$(EPUB_STYLE)/ncx.xsl $(XML_BUILD_DIR)/%.xml $(TEMP_DIR)/%-epub/content.opf
	# Create the NCX file which has placeholders for the sequence.
	mkdir -p $(TEMP_DIR)/$*-epub
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/epub/$(EPUB_STYLE)/ncx.xsl \
		-s:$(XML_BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-epub/toc.ncx

	# The NCX file's unique identifier needs to match the OPF files,
	# that is why we depend on the OPF file.
	mfgames-ncx meta-set $(TEMP_DIR)/$*-epub/toc.ncx dtb:uid \
		$(shell mfgames-opf uid-get $(TEMP_DIR)/$*-epub/content.opf)

$(JPG_BUILD_DIR)/%.jpg: $(SOURCE_DIR)/%.jpg
	mkdir -p $(JPG_BUILD_DIR)/$(dir $*)
	cp $(SOURCE_DIR)/$*.jpg $(JPG_BUILD_DIR)/$*.jpg

$(JPG_BUILD_DIR)/%.jpg: $(XML_BUILD_DIR)/%.xml $(STYLE_DIR)/cover/$(COVER_STYLE).xsl
	# We have to create a cover using `fop`.
	mkdir -p $(TEMP_DIR)/$*-cover
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/cover/$(COVER_STYLE).xsl \
		-s:$(XML_BUILD_DIR)/$*.xml \
		-o:$(TEMP_DIR)/$*-cover/cover.fop

	# Create the PNG version of the cover.
	fop $(TEMP_DIR)/$*-cover/cover.fop -png $(TEMP_DIR)/$*-cover/cover.png

	# Convert the PNG to JPG.
	convert $(TEMP_DIR)/$*-cover/cover.png -quality 75 $(JPG_BUILD_DIR)/$*.jpg

$(TEMP_DIR)/%-epub/cover.jpg: $(JPG_BUILD_DIR)/%.jpg
	mkdir -p $(TEMP_DIR)/$*-epub
	cp $(JPG_BUILD_DIR)/$*.jpg $(TEMP_DIR)/$*-epub/cover.jpg

$(TEMP_DIR)/%.epub: $(XML_BUILD_DIR)/%.xml $(TEMP_DIR)/%-epub/content.html $(TEMP_DIR)/%-epub/toc.html $(TEMP_DIR)/%-epub/toc.ncx $(TEMP_DIR)/%-epub/content.opf $(TEMP_DIR)/%-epub/cover.html $(TEMP_DIR)/%-epub/cover.jpg
	# Remove any existing epub file, because we have to rebuild it.
	rm -f $(TEMP_DIR)/$*.epub

	# Create the mimetype file.
	echo -n "application/epub+zip" > $(TEMP_DIR)/$*-epub/mimetype

	# Create the META-INF directory.
	mkdir -p $(TEMP_DIR)/$*-epub/META-INF
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

$(EPUB_BUILD_DIR)/%.epub: $(TEMP_DIR)/%.epub
	mkdir -p $(EPUB_BUILD_DIR)/$(dir $*)
	cp $(TEMP_DIR)/$*.epub $(EPUB_BUILD_DIR)/$*.epub

#
# MOBI
#

$(MOBI_BUILD_DIR)/%.mobi: $(EPUB_BUILD_DIR)/%.epub
	# Create our temporary directory.
	-rm -r $(TEMP_DIR)/$*-mobi/*
	mkdir -p $(TEMP_DIR)/$*-mobi

	# Move the EPUB file into that directory and expand it.
	cp $(EPUB_BUILD_DIR)/$*.epub $(TEMP_DIR)/$*-mobi/content.epub
	cd $(TEMP_DIR)/$*-mobi && unzip content.epub
	rm $(TEMP_DIR)/$*-mobi/content.epub

	# Remove the cover.html since `kindlegen` does not support it.
	mfgames-opf manifest-remove $(TEMP_DIR)/$*-mobi/content.opf cover
	mfgames-opf spine-remove $(TEMP_DIR)/$*-mobi/content.opf cover
	mfgames-opf cover-set $(TEMP_DIR)/$*-mobi/content.opf cover-image
	mfgames-ncx nav-remove $(TEMP_DIR)/$*-mobi/toc.ncx cover
	rm $(TEMP_DIR)/$*-mobi/cover.html

	# Build the mobi file inside the directory.
	cd $(TEMP_DIR)/$*-mobi && $(KINDLEGEN) content.opf

	# Move the mobi file into the proper location.
	mv $(TEMP_DIR)/$*-mobi/content.mobi $(MOBI_BUILD_DIR)/$*.mobi

	# Clean up all the temporary files.
	rm -rf $(TEMP_DIR)/$*-mobi

#
# HTML
#

$(HTML_BUILD_DIR)/%.html: $(XML_BUILD_DIR)/%.xml
	saxonb-xslt \
		-xsl:$(STYLE_DIR)/html/$(HTML_STYLE).xsl \
		-s:$(XML_BUILD_DIR)/$*.xml \
		-o:$(HTML_BUILD_DIR)/$*.html

#
# Guides
#

.PRECIOUS: $(JPG_BUILD_DIR)/%.jpg $(MOBI_BUILD_DIR)/%.mobi $(EPUB_BUILD_DIR)/%.epub $(PDF_BUILD_DIR)/%.pdf $(ODT_BUILD_DIR)/%.odt $(DOC_BUILD_DIR)/%.doc