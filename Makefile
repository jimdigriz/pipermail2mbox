# SPDX-License-Identifier: Unlicense

SHELL = /bin/sh
.DELETE_ON_ERROR:

CLEAN =
DISTCLEAN =

ifeq ($(URL),)
$(error please set URL)
endif

LIST = $(lastword $(subst /, ,$(URL)))

.PHONY: all
all: INDEX = data/$(LIST)/index
all:
	@mkdir -p $(dir $(INDEX))
	curl -f -z $(INDEX) -o $(INDEX) $(URL)
	make mbox/$(LIST).mbox.gz URL=$(URL)
CLEAN += data/$(LIST)/index

data/%/mboxes: data/%/index
	sed -ne 's/.*"\([^.]\+\.txt\.gz\)".*/\1/ p' $< > $@
CLEAN += data/$(LIST)/mboxes

mbox/$(LIST).mbox.gz: data/$(LIST)/mboxes
	@mkdir -p $(@D)
	curl -f $(foreach MBOX,$(shell cat $<),-: -z data/$(LIST)/$(MBOX) -o data/$(LIST)/$(MBOX) $(URL)$(MBOX))
	echo $(addprefix data/$(LIST)/,$(shell cat $<)) | xargs -r touch -r $<
	cat $(addprefix data/$(LIST)/,$(shell cat $<)) > $@
CLEAN += mbox/$(LIST).mbox.gz
DISTCLEAN += $(filter-out index mboxes,$(wildcard data/$(LIST)/*))

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
