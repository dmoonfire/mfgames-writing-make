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
KINDLEGEN				?= kindlegen

PANDOC					?= pandoc
PANDOC_ARGS				?= --smart
PANDOC_EPUB				?= $(PANDOC_ARGS) -t epub
PANDOC_EPUB_STANDALONE	?= $(PANDOC_EPUB) -s --toc --epub-chapter-level=2
PANDOC_PDF				?= $(PANDOC_ARGS)
PANDOC_HTML				?= $(PANDOC_ARGS) -t html5 --section-divs
PANDOC_HTML_STANDALONE	?= $(PANDOC_HTML) -s --toc

BUILD_DIR				?= build

#
# HTML
#

$(BUILD_DIR)/%-html.markdown: make-build %.markdown
	$(MARKDOWN_INCLUDE) $*.markdown --output=$(BUILD_DIR)/$*-html.markdown

$(BUILD_DIR)/%.html: $(BUILD_DIR)/%-html.markdown
	$(PANDOC) $(PANDOC_HTML_STANDALONE) $(BUILD_DIR)/$*-html.markdown -o $(BUILD_DIR)/$*.html

#
# EPUB
#

$(BUILD_DIR)/%-epub.jpg: %.jpg
	cp $*.jpg $(BUILD_DIR)/$*-epub.jpg

$(BUILD_DIR)/%-epub.png: $(BUILD_DIR)/%-epub.markdown
	$(WRITING_DIR)/../make-cover "$(shell grep title: $(BUILD_DIR)/$*-epub.markdown | head -1 | cut -f 2- -d:)" "$(shell grep author: $(BUILD_DIR)/$*-epub.markdown | head -1 | cut -f 2- -d:)" $(BUILD_DIR)/$*-epub.png

$(BUILD_DIR)/%-epub.jpg: $(BUILD_DIR)/%-epub.png
	convert $(BUILD_DIR)/$*-epub.png $(BUILD_DIR)/$*-epub.jpg

$(BUILD_DIR)/%-epub.markdown: make-build %.markdown
	$(MARKDOWN_INCLUDE) $*.markdown --output=$(BUILD_DIR)/$*-epub.markdown

$(BUILD_DIR)/%.epub: $(BUILD_DIR)/%-epub.markdown $(BUILD_DIR)/%-epub.jpg
	$(PANDOC) $(PANDOC_EPUB_STANDALONE) $(BUILD_DIR)/$*-epub.markdown -o $(BUILD_DIR)/$*.epub --epub-cover-image=$(BUILD_DIR)/$*-epub.jpg

#
# MOBI
#

$(BUILD_DIR)/%.mobi: $(BUILD_DIR)/%.epub
	$(KINDLEGEN) $(BUILD_DIR)/$*.epub

#
# Common
#

make-build:
	if [ ! -d $(BUILD_DIR) ];then mkdir -p $(BUILD_DIR);fi

clean:
	rm -fr $(BUILD_DIR)
	rm -f *~
