# -*- makefile -*-

# MfGames Writing Make v4.0.0
#
# Primary include file for a chapter-based layout.

#
# Defaults
#
# The assumption is that the files in the root directory along with
# the Makefile are the "root" or indexes for the system.

INDEXES       ?= $(wildcard *.markdown)
BUILD_INDEXES ?= $(addprefix $(BUILD_DIR)/,$(INDEXES))
BUILD_EPUB    ?= $(BUILD_INDEXES:markdown=epub)
BUILD_PDF     ?= $(BUILD_INDEXES:markdown=pdf)
BUILD_MOBI    ?= $(BUILD_INDEXES:markdown=mobi)
BUILD_HTML    ?= $(BUILD_INDEXES:markdown=html)

# Set up our default indexes.
v4-chapters:
	$(MAKE) $(BUILD_HTML) $(BUILD_EPUB) $(BUILD_MOBI)

# Include the common logic.
include $(WRITING_DIR)/include.make
