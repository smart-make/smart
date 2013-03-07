#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

define smart~rule
  NATIVE_LIBS += $(OUT)/$(NAME)/lib/$(1:$(SRCDIR)/libs/%=%)
  $(OUT)/$(NAME)/lib/$(1:$(SRCDIR)/libs/%=%) : $1
	mkdir -p $$(@D) && cp -f $$< $$@
endef #smart~rule

$(foreach 1,$(LIBS.native),$(eval $(smart~rule)))

ifdef NATIVE_LIBS
define smart~rule
  $(OUT)/$(NAME)/_.pack: PACK_COMMANDS += && cd "$$(@D)" && zip -r $$(@F) $(NATIVE_LIBS:$(OUT)/$(NAME)/%=%)
  $(OUT)/$(NAME)/_.pack: $(NATIVE_LIBS)
endef #smart~rule
$(eval $(smart~rule))
endif #NATIVE_LIBS

smart~rule =
