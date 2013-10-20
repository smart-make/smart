#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~native :=

$(OUT)/$(NAME)/$V/_.pack: pack_libs = true
$(OUT)/$(NAME)/$V/_.pack: natives :=

# process .so libs
ifdef LIBS.native
  define smart~rule
    smart~native += $(OUT)/$(NAME)/$V/lib/$(1:$(SRCDIR)/libs/%=%)
    $(OUT)/$(NAME)/$V/lib/$(1:$(SRCDIR)/libs/%=%): $1
	mkdir -p $$(@D) && cp -f $$< $$@
  endef #smart~rule
  $(foreach 1,$(LIBS.native),$(eval $(smart~rule)))
endif #LIBS.native

# process .native lib lists
ifdef LIBS.native_list
  define smart~rule
  $(OUT)/$(NAME)/$V/_.pack: pack_libs += && ( bash $(smart.tooldir)/copy-native.bash "$(OUT)/$(NAME)/$V" "$$(@F)" "$1")
  $(OUT)/$(NAME)/$V/_.pack: $1
  endef #smart~rule
  $(foreach 1,$(LIBS.native_list),$(eval $(smart~rule)))
endif #LIBS.native_list

# process packing native .so libs
ifdef smart~native
  $(OUT)/$(NAME)/$V/_.pack: natives := $(smart~native:$(OUT)/$(NAME)/$V/%=%)
  $(OUT)/$(NAME)/$V/_.pack: pack_libs += && ( bash $(smart.tooldir)/pack-file.bash "$(@D)" "$(@F)" "$(natives)" )
  $(OUT)/$(NAME)/$V/_.pack: $(smart~native)
endif #smart~native
