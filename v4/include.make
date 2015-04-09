# -*- makefile -*-

# MfGames Writing Make v4.0.0
#
# This is a Makefile-based build system for working with novels and
# stories.
#
# To setup:
#	1. Create a Makefile that includes this file.
#	2. Run it with `make build/name-of-file.pdf`

#
# Defaults
#

MARKDOWN_INCLUDE		?= markdown-include
MARKDOWN_EXTRACT		?= markdown-extract
KINDLEGEN				?= kindlegen
EPUBCHECK				?= epubcheck

PANDOC					?= pandoc
PANDOC_ARGS				?= --smart
PANDOC_EPUB				?= $(PANDOC_ARGS) -t epub
PANDOC_EPUB_CSS         ?= $(WRITING_DIR)/templates/epub.css
PANDOC_EPUB_STANDALONE	?= $(PANDOC_EPUB) -s --toc --epub-chapter-level=2
PANDOC_PDF				?= $(PANDOC_ARGS)
PANDOC_HTML				?= $(PANDOC_ARGS) -t html5 --section-divs
PANDOC_HTML_STANDALONE	?= $(PANDOC_HTML) -s --toc

BUILD_DIR				?= build

#
# HTML
#

$(BUILD_DIR)/%-html.markdown: %.markdown
	if [ ! -d $(BUILD_DIR) ];then mkdir -p $(BUILD_DIR);fi
	$(MARKDOWN_INCLUDE) $*.markdown --output=$(BUILD_DIR)/$*-html.markdown

$(BUILD_DIR)/%.html: $(BUILD_DIR)/%-html.markdown
	$(PANDOC) $(PANDOC_HTML_STANDALONE) $(BUILD_DIR)/$*-html.markdown -o $(BUILD_DIR)/$*.html

#
# EPUB
#
# Unfortunately, `pandoc` doesn't allow us to use -B to insert HTML
# files before the table of contents. So, we have to call a Perl
# script to clean up the resulting document to fit closer to the book:
#
# 1. Move the legal page after the title but before the table of contents
# 2. Remove the title from the legal page
# 3. Remove the TOC entry for the legal page
# 4. Move the dedication before the table of contents
# 5. Remove the title for the dedication
# 6. Rename table of contents to be "Table of Contents"

# Image
$(BUILD_DIR)/%-epub.jpg: %.jpg
	if [ ! -d $(BUILD_DIR) ];then mkdir -p $(BUILD_DIR);fi
	cp $*.jpg $(BUILD_DIR)/$*-epub.jpg

$(BUILD_DIR)/%-epub.png: $(BUILD_DIR)/%-epub.markdown
	if [ ! -d $(BUILD_DIR) ];then mkdir -p $(BUILD_DIR);fi
	$(WRITING_DIR)/../make-cover "$(shell grep title: $(BUILD_DIR)/$*-epub.markdown | head -1 | cut -f 2- -d:)" "$(shell grep author: $(BUILD_DIR)/$*-epub.markdown | head -1 | cut -f 2- -d:)" $(BUILD_DIR)/$*-epub.png

$(BUILD_DIR)/%-epub.jpg: $(BUILD_DIR)/%-epub.png
	convert $(BUILD_DIR)/$*-epub.png $(BUILD_DIR)/$*-epub.jpg

# Content
$(BUILD_DIR)/%-epub.markdown: %.markdown
	if [ ! -d $(BUILD_DIR) ];then mkdir -p $(BUILD_DIR);fi
	$(MARKDOWN_INCLUDE) $*.markdown --output=$(BUILD_DIR)/$*-epub.markdown

$(BUILD_DIR)/epub.css: $(PANDOC_EPUB_CSS)
	if [ ! -d $(BUILD_DIR) ];then mkdir -p $(BUILD_DIR);fi
	cp $(PANDOC_EPUB_CSS) $(BUILD_DIR)/epub.css

$(BUILD_DIR)/%.epub: $(BUILD_DIR)/%-epub.markdown $(BUILD_DIR)/%-epub.jpg $(BUILD_DIR)/epub.css
	$(PANDOC) $(PANDOC_EPUB_STANDALONE) -o $(BUILD_DIR)/$*.epub --epub-cover-image=$(BUILD_DIR)/$*-epub.jpg --epub-stylesheet=$(BUILD_DIR)/epub.css $(BUILD_DIR)/$*-epub.markdown --data-dir=$(BUILD_DIR)
	$(WRITING_DIR)/arrange-epub $(BUILD_DIR)/$*.epub --verbose
	rm $(BUILD_DIR)/epub.css
	$(EPUBCHECK) $(BUILD_DIR)/$*.epub

#
# MOBI
#

$(BUILD_DIR)/%.mobi: $(BUILD_DIR)/%.epub
	$(KINDLEGEN) $(BUILD_DIR)/$*.epub

#
# Common
#

clean:
	rm -fr $(BUILD_DIR)
	rm -f *~
