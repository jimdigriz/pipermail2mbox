# SPDX-License-Identifier: Unlicense

SHELL = /bin/sh
.DELETE_ON_ERROR:

CLEAN =
DISTCLEAN =

ifeq ($(URL),)
$(error please set URL)
endif

LIST = $(lastword $(subst /, ,$(URL)))

CURL = curl -fsSRL --retry 3 -o $(2) $(if $(shell test -f $(2) && echo y),-z $(2) )$(1)

.PHONY: all
all: cache/$(LIST)/mboxes
	$(MAKE) $(LIST).mbox.gz URL=$(URL)

$(LIST).mbox.gz: $(foreach MBOX,$(shell cat cache/$(LIST)/mboxes),cache/$(LIST)/$(MBOX)) | cache/$(LIST)/mboxes
	find cache/$(LIST) -type f -name '*.txt.gz' | xargs cat > $@
CLEAN += $(wildcard *.mbox.gz)

cache/%/index:
	@mkdir -p $(@D)
	$(call CURL,$(URL),$@)
CLEAN += $(wildcard cache/*/index)

cache/%/mboxes: cache/%/index
	sed -ne 's/.*"\([^.]\+\.txt\.gz\)".*/\1/ p' $< > $@
CLEAN += $(wildcard cache/*/mboxes)

cache/$(LIST)/%.txt.gz:
	$(call CURL,$(URL)$(@F),$@)
DISTCLEAN = $(wildcard cache/*/*.txt.gz)

.PHONY: clean
clean:
ifneq ($(CLEAN),)
	rm -rf $(CLEAN)
endif

.PHONY: distclean
distclean: clean
ifneq ($(DISTCLEAN),)
	rm -rf $(DISTCLEAN)
endif
