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
XELATEX					?= buf_size=2500000 xelatex

PANDOC					?= pandoc
PANDOC_ARGS				?= --smart --normalize
PANDOC_EPUB_CSS         ?= $(WRITING_DIR)/templates/epub.css
PANDOC_EPUB				?= $(PANDOC_ARGS) -t epub
PANDOC_EPUB_STANDALONE	?= $(PANDOC_EPUB) -s --toc --epub-chapter-level=2
PANDOC_PDF				?= $(PANDOC_ARGS)
PANDOC_HTML				?= $(PANDOC_ARGS) -t html5 --section-divs
PANDOC_HTML_STANDALONE	?= $(PANDOC_HTML) -s --toc
PANDOC_TEX				?= $(PANDOC_ARGS) -t latex --no-tex-ligatures --chapters
PANDOC_TEX_STANDALONE	?= $(PANDOC_TEX) -s

BUILD_DIR				?= build

# Default to building all the Markdown files in the Makefile directory.
INDEXES       ?= $(wildcard *.markdown)
BUILD_INDEXES ?= $(addprefix $(BUILD_DIR)/,$(INDEXES))
BUILD_EPUB    ?= $(BUILD_INDEXES:markdown=epub)
BUILD_PDF     ?= $(BUILD_INDEXES:markdown=pdf)
BUILD_MOBI    ?= $(BUILD_INDEXES:markdown=mobi)
BUILD_HTML    ?= $(BUILD_INDEXES:markdown=html)


#
# Common
#

# We call Make directly on these becaues the dependencies doesn't work
# as well.
v4:
	$(MAKE) $(BUILD_HTML) $(BUILD_EPUB) $(BUILD_MOBI)

clean:
	rm -fr $(BUILD_DIR)
	rm -f *~

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
	$(WRITING_DIR)/../make-cover "$(shell grep title: $(BUILD_DIR)/$*-epub.markdown | head -1 | cut -f 2- -d: | cut -c 2-)" "$(shell grep author: $(BUILD_DIR)/$*-epub.markdown | head -1 | cut -f 2- -d: | cut -c 2-)" $(BUILD_DIR)/$*-epub.png

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
	$(WRITING_DIR)/arrange-epub $(BUILD_DIR)/$*.epub
	rm $(BUILD_DIR)/epub.css
	$(EPUBCHECK) $(BUILD_DIR)/$*.epub

#
# LaTeX
#

$(BUILD_DIR)/%-tex:
	if [ ! -d $(BUILD_DIR)/$*-tex ];then mkdir -p $(BUILD_DIR)/$*-tex;fi
	cp $(WRITING_DIR)/latex/*.tex $(BUILD_DIR)/$*-tex

$(BUILD_DIR)/%-tex.markdown: %.markdown
	if [ ! -d $(BUILD_DIR) ];then mkdir -p $(BUILD_DIR);fi
	$(MARKDOWN_INCLUDE) $*.markdown --output=$(BUILD_DIR)/$*-tex.markdown --strip

$(BUILD_DIR)/%-tex-legal.markdown: $(BUILD_DIR)/%-tex.markdown
	$(MARKDOWN_EXTRACT) $(BUILD_DIR)/$*-tex.markdown -o $(BUILD_DIR)/$*-tex-legal.markdown --id=legal

$(BUILD_DIR)/%-tex/before-21-legal.tex: $(BUILD_DIR)/%-tex $(BUILD_DIR)/%-tex-legal.markdown
	$(PANDOC) $(PANDOC_TEX) $(BUILD_DIR)/$*-tex-legal.markdown -o $(BUILD_DIR)/$*-tex/before-21-legal.tex

$(BUILD_DIR)/%-tex-dedication.markdown: $(BUILD_DIR)/%-tex.markdown
	$(MARKDOWN_EXTRACT) $(BUILD_DIR)/$*-tex.markdown -o $(BUILD_DIR)/$*-tex-dedication.markdown --id=dedication

$(BUILD_DIR)/%-tex/before-31-dedication.tex: $(BUILD_DIR)/%-tex $(BUILD_DIR)/%-tex-dedication.markdown
	$(PANDOC) $(PANDOC_TEX) $(BUILD_DIR)/$*-tex-dedication.markdown -o $(BUILD_DIR)/$*-tex/before-31-dedication.tex

$(BUILD_DIR)/%-tex-backmatter.markdown: $(BUILD_DIR)/%-tex.markdown
	$(MARKDOWN_EXTRACT) $(BUILD_DIR)/$*-tex.markdown -o $(BUILD_DIR)/$*-tex-backmatter.markdown --class=backmatter

$(BUILD_DIR)/%-tex/after-31-backmatter.tex: $(BUILD_DIR)/%-tex $(BUILD_DIR)/%-tex-backmatter.markdown
	$(PANDOC) $(PANDOC_TEX) $(BUILD_DIR)/$*-tex-backmatter.markdown -o $(BUILD_DIR)/$*-tex/after-31-backmatter.tex

$(BUILD_DIR)/%-tex-mainmatter.markdown: $(BUILD_DIR)/%-tex.markdown
	$(MARKDOWN_EXTRACT) $(BUILD_DIR)/$*-tex.markdown -o $(BUILD_DIR)/$*-tex-mainmatter.markdown --class=backmatter --id=legal --id=dedication --not --yaml

$(BUILD_DIR)/%.tex: $(BUILD_DIR)/%-tex-mainmatter.markdown $(BUILD_DIR)/%-tex/before-21-legal.tex $(BUILD_DIR)/%-tex/before-31-dedication.tex $(BUILD_DIR)/%-tex/after-31-backmatter.tex 
	if [ ! -d $(BUILD_DIR) ];then mkdir -p $(BUILD_DIR);fi
	$(PANDOC) $(PANDOC_TEX_STANDALONE) $(BUILD_DIR)/$*-tex-mainmatter.markdown --output=$(BUILD_DIR)/$*.tex $(addprefix -B ,$(shell ls $(BUILD_DIR)/$*-tex/before-*.tex)) $(addprefix -A ,$(shell ls $(BUILD_DIR)/$*-tex/after-*.tex))
	rm -rf $(BUILD_DIR)/$*-tex

#
# PDF
#

$(BUILD_DIR)/%.pdf: $(BUILD_DIR)/%.tex
	cd $(BUILD_DIR) && $(XELATEX) -halt-on-error $*.tex > /dev/null
	cd $(BUILD_DIR) && $(XELATEX) -halt-on-error $*.tex > /dev/null
	cd $(BUILD_DIR) && $(XELATEX) -halt-on-error $*.tex > /dev/null
	rm -f $(BUILD_DIR)/$*.log
	rm -f $(BUILD_DIR)/$*.aux
	rm -f $(BUILD_DIR)/$*.out
	rm -f $(BUILD_DIR)/$*.toc

#
# MOBI
#

$(BUILD_DIR)/%.mobi: $(BUILD_DIR)/%.epub
	$(KINDLEGEN) $(BUILD_DIR)/$*.epub
