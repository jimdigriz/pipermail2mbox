# SPDX-License-Identifier: Unlicense

SHELL = /bin/sh
.DELETE_ON_ERROR:
.SECONDARY_EXPANSIONS:

CLEAN =
DISTCLEAN =

ifeq ($(URL),)
$(error please set URL)
endif

LIST = $(lastword $(subst /, ,$(URL)))

CURL = curl -fsSRL --retry 3 -o $(2) $(if $(shell test -f $(2) && echo y),-z $(2) )$(1)

.PHONY: all
all: cache/$(LIST)/mboxes
	$(MAKE) $(LIST).mbox.gz URL=$(URL) STAGE=2

$(LIST).mbox.gz: $(if $(shell test -f cache/$(LIST)/mboxes && echo y),$(foreach MBOX,$(shell cat cache/$(LIST)/mboxes),cache/$(LIST)/$(MBOX)))
	find cache/$(LIST) -type f -name '*.txt.gz' | xargs cat > $@
CLEAN += $(wildcard *.mbox.gz)

cache/$(LIST)/%.txt.gz: cache/$(LIST)/mboxes
	$(call CURL,$(URL)$(@F),$@)
	@touch -r $< $@
DISTCLEAN = $(wildcard cache/*/*.txt.gz)

cache/%/mboxes: cache/%/index
	sed -ne 's/.*"\([^.]\+\.txt\.gz\)".*/\1/ p' $< > $@
	@touch -r $< $@

ifneq ($(STAGE),2)
.PHONY: cache/$(LIST)/index
endif
cache/$(LIST)/index:
	@mkdir -p $(@D)
	$(call CURL,$(URL),$@)
CLEAN += $(wildcard cache/*/index)

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
