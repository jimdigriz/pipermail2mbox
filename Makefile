SHELL = /bin/sh
.DELETE_ON_ERROR:

CLEAN =
DISTCLEAN =

ifeq ($(URL),)
$(error please set URL)
endif

LIST = $(lastword $(subst /, ,$(URL)))

.PHONY: all
all: mbox/$(LIST).mbox.gz

data/$(LIST)/index:
	@mkdir -p $(@D)
	curl -f -z $@ -o $@ $(URL)
CLEAN += data/$(LIST)/index

data/%/mboxes: data/%/index
	sed -ne 's/.*"\([^.]\+\.txt\.gz\)".*/\1/ p' $< > $@

mbox/$(LIST).mbox.gz: data/$(LIST)/mboxes
	@mkdir -p $(@D)
	curl -f $(foreach MBOX,$(shell cat $<),-z data/$(LIST)/$(MBOX) -o data/$(LIST)/$(MBOX) $(URL)$(MBOX))
	cat $(addprefix data/$(LIST)/,$(shell cat $<)) > $@
CLEAN += mbox/$(LIST).mbox.gz
DISTCLEAN += $(wildcard data/$(LIST)/*)

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
