#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~native :=

define smart~rule
  smart~native += $(OUT)/$(NAME)/lib/$(1:$(SRCDIR)/libs/%=%)
  $(OUT)/$(NAME)/lib/$(1:$(SRCDIR)/libs/%=%) : $1
	mkdir -p $$(@D) && cp -f $$< $$@
endef #smart~rule

$(foreach 1,$(LIBS.native),$(eval $(smart~rule)))

ifdef smart~native
define smart~rule
  $(OUT)/$(NAME)/_.pack: PACK_COMMANDS += && cd "$$(@D)" && zip -r $$(@F) $(smart~native:$(OUT)/$(NAME)/%=%)
  $(OUT)/$(NAME)/_.pack: $(smart~native)
endef #smart~rule
$(eval $(smart~rule))
endif #smart~native

smart~rule =
