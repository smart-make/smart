#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~native :=

$(OUT)/$(NAME)/_.pack: pack_libs = true
$(OUT)/$(NAME)/_.pack: natives :=

# process .so libs
ifdef LIBS.native
  define smart~rule
    smart~native += $(OUT)/$(NAME)/lib/$(1:$(SRCDIR)/libs/%=%)
    $(OUT)/$(NAME)/lib/$(1:$(SRCDIR)/libs/%=%): $1
	mkdir -p $$(@D) && cp -f $$< $$@
  endef #smart~rule
  $(foreach 1,$(LIBS.native),$(eval $(smart~rule)))
endif #LIBS.native

# process .native lib lists
ifdef LIBS.native_list
  define smart~rule
  $(OUT)/$(NAME)/_.pack: pack_libs += && ( bash $(smart.tooldir)/copy-native.bash "$(OUT)/$(NAME)" "$$(@F)" "$1")
  $(OUT)/$(NAME)/_.pack: $1
  endef #smart~rule
  $(foreach 1,$(LIBS.native_list),$(eval $(smart~rule)))
endif #LIBS.native_list

# process packing native .so libs
ifdef smart~native
  $(OUT)/$(NAME)/_.pack: natives := $(smart~native:$(OUT)/$(NAME)/%=%)
  $(OUT)/$(NAME)/_.pack: pack_libs += && ( bash $(smart.tooldir)/pack-file.bash "$(@D)" "$(@F)" "$(natives)" )
  $(OUT)/$(NAME)/_.pack: $(smart~native)
endif #smart~native
