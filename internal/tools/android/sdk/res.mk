#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~res.all := $(MANIFEST) \
  $(wildcard $(RES) $(SRCDIR)/res $(SRCDIR)/assets) \
  $(foreach 1,$(RES) $(SRCDIR)/res,\
      $(call smart.find,$1,%.xml %.png %.jpg,%~)) \
  $(call smart.find,$(SRCDIR)/assets,,%~)

define smart~rule
  $(OUT)/$(NAME)/res.pro:
	@echo "Gen $$@.."
	@touch $$@
  $(OUT)/$(NAME)/public.xml \
  $(OUT)/$(NAME)/res/.sources: $(LIBS.java) $(smart~res.all)
	@mkdir -p $$(@D)
	$(ANDROID.aapt) package -f -m -J "$(OUT)/$(NAME)/res" \
	-P "$(OUT)/$(NAME)/public.xml" \
	$(addprefix --custom-package ,"$(R_PACKAGE)") \
	$(addprefix -M ,$(wildcard $(MANIFEST))) \
        $(addprefix -I ,"$(ANDROID_PLATFORM_LIB)") \
	$(foreach 1,$(LIBS.java),-I "$1") \
	$(foreach 1,$(RES) $(SRCDIR)/res,$(addprefix -S ,$(wildcard $1))) \
	$(foreach 1,$(RES) $(SRCDIR)/assets,$(addprefix -A ,$(wildcard $1)))
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
	$(foreach 1,$(RES) $(SRCDIR)/res,$(addprefix -S ,$(wildcard $1))) \
	$(foreach 1,$(RES) $(SRCDIR)/assets,$(addprefix -A ,$(wildcard $1)))

  $(OUT)/$(NAME)/_.pack: PACK_COMMANDS = cp -f "$(OUT)/$(NAME)/res/.packed" "$$@"
  $(OUT)/$(NAME)/_.pack: $(OUT)/$(NAME)/res/.packed
endef #smart~rule

$(eval $(smart~rule))

smart~rule =
