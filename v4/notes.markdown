---
title: Notes
---

* Pandoc Extensions
	* yaml_metadata_block

$(BUILD_DIR)/%-html.markdown: make-build %.markdown
	$(MARKDOWN_INCLUDE) $*.markdown --output=$(BUILD_DIR)/$*-html.markdown

$(BUILD_DIR)/%-html-legal.markdown: $(BUILD_DIR)/%-html.markdown
	$(MARKDOWN_EXTRACT) $(BUILD_DIR)/$*-html.markdown --output=$(BUILD_DIR)/$*-html-legal.markdown --id=legal

$(BUILD_DIR)/%-html-1.markdown: $(BUILD_DIR)/%-html.markdown
	$(MARKDOWN_EXTRACT) $(BUILD_DIR)/$*-html.markdown --output=$(BUILD_DIR)/$*-html-1.markdown --id=legal --not

$(BUILD_DIR)/%-html-legal.html: $(BUILD_DIR)/%-html-legal.markdown
	$(PANDOC) $(PANDOC_HTML) $(BUILD_DIR)/$*-html-legal.markdown | grep -v '<h1' > $(BUILD_DIR)/$*-html-legal.html

$(BUILD_DIR)/%.html: $(BUILD_DIR)/%-html-legal.html $(BUILD_DIR)/%-html-1.markdown
	$(PANDOC) $(PANDOC_HTML_STANDALONE) $(BUILD_DIR)/$*-html-1.markdown -o $(BUILD_DIR)/$*.html -B $(BUILD_DIR)/$*-html-legal.html
