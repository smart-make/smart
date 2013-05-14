#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~res.all := $(MANIFEST) \
  $(wildcard $(SRCDIR)/res $(SRCDIR)/assets $(RES) $(ASSETS)) \
  $(foreach 1,$(SRCDIR)/res $(RES),\
      $(call smart.find,$1,%.xml %.png %.jpg,%~)) \
  $(foreach 1,$(SRCDIR)/assets $(RES) $(ASSETS),\
      $(call smart.find,$1,,%~))

define smart~rule
  $(OUT)/$(NAME)/res.pro:
	@echo "Gen $$@.."
	@mkdir -p $$(@D) && touch $$@
  $(OUT)/$(NAME)/public.xml \
  $(OUT)/$(NAME)/res/.sources: $(LIBS.java) $(smart~res.all)
	@mkdir -p $$(@D)
	$(ANDROID.aapt) package -f -m -J "$(OUT)/$(NAME)/res" \
	-P "$(OUT)/$(NAME)/public.xml" \
	$(addprefix --custom-package ,"$(R_PACKAGE)") \
	$(addprefix -M ,$(wildcard $(MANIFEST))) \
        $(addprefix -I ,"$(ANDROID_PLATFORM_LIB)") \
	$(foreach 1,$(LIBS.java),-I "$1") \
	$(foreach 1,$(SRCDIR)/res $(RES),$(addprefix -S ,$(wildcard $1))) \
	$(foreach 1,$(SRCDIR)/assets $(ASSETS),$(addprefix -A ,$(wildcard $1)))
	@find $(OUT)/$(NAME)/res -type f -name R.java > $$@
endef #smart~rule

$(eval $(smart~rule))

define smart~rule
  $(OUT)/$(NAME)/res/.packed: $(LIBS.java) $(smart~res.all)
	@mkdir -p $$(@D)
	$(ANDROID.aapt) package -u -F $$@ $(if $(PACKAGE),-x) \
	$(addprefix -M ,$(wildcard $(MANIFEST))) \
        $(addprefix -I ,"$(ANDROID_PLATFORM_LIB)") \
	$(foreach 1,$(LIBS.java),-I "$1") \
	$(foreach 1,$(SRCDIR)/res $(RES),$(addprefix -S ,$(wildcard $1))) \
	$(foreach 1,$(SRCDIR)/assets $(ASSETS),$(addprefix -A ,$(wildcard $1)))

  $(OUT)/$(NAME)/_.pack: PACK_COMMANDS = cp -f "$(OUT)/$(NAME)/res/.packed" "$$@"
  $(OUT)/$(NAME)/_.pack: $(OUT)/$(NAME)/res/.packed
endef #smart~rule

$(eval $(smart~rule))

smart~rule =
