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
	$(ANDROID.aapt) package -f -m \
	--output-text-symbols "$(OUT)/$(NAME)" --auto-add-overlay \
	$(addprefix --custom-package ,$(R_PACKAGE)) \
	$(addprefix -M ,$(wildcard $(MANIFEST))) \
	$(foreach 1,$(LIBS.java) $(ANDROID_PLATFORM_LIB),-I "$1") \
	$(foreach 1,$(SRCDIR)/res $(RES),$(addprefix -S ,$(wildcard $1))) \
	$(foreach 1,$(SRCDIR)/assets $(ASSETS),$(addprefix -A ,$(wildcard $1))) \
	-J "$(OUT)/$(NAME)/res" --generate-dependencies \
	-P "$(OUT)/$(NAME)/public.xml"
	@find $(OUT)/$(NAME)/res -type f -name '*.java' > $$@
  -include $(OUT)/$(NAME)/res/R.java.d
endef #smart~rule

$(eval $(smart~rule))
#$(warning $(RES), $(wildcard $(RES)))

define smart~rule
  $(OUT)/$(NAME)/res/.packed: $(LIBS.java) $(smart~res.all)
	@mkdir -p $$(@D)
	$(ANDROID.aapt) package -u -F $$@ $(if $(PACKAGE),-x) \
	$(addprefix -M ,$(wildcard $(MANIFEST))) \
        $(addprefix -I ,$(ANDROID_PLATFORM_LIB)) \
	$(foreach 1,$(LIBS.java),-I "$1") \
	$(foreach 1,$(SRCDIR)/res $(RES),$(addprefix -S ,$(wildcard $1))) \
	$(foreach 1,$(SRCDIR)/assets $(ASSETS),$(addprefix -A ,$(wildcard $1)))

  $(OUT)/$(NAME)/_.pack: PACK_COMMANDS = cp -f "$(OUT)/$(NAME)/res/.packed" "$$@"
  $(OUT)/$(NAME)/_.pack: $(OUT)/$(NAME)/res/.packed
endef #smart~rule

$(eval $(smart~rule))

smart~rule =


# Executing '/store/open/android-sdk/build-tools/17.0.0/aapt' with arguments:
# 'crunch'
# '-v'
# '-S'
# '/store/open/ActionBarSherlock/actionbarsherlock/res'
# '-C'
# '/store/open/ActionBarSherlock/actionbarsherlock/bin/res'


# Executing '/store/open/android-sdk/build-tools/17.0.0/aapt' with arguments:
# 'package'
# '-f'
# '-m'
# '--output-text-symbols'
# '/store/open/CSipSimple/bin'
# '--auto-add-overlay'
# '-M'
# '/store/open/CSipSimple/bin/AndroidManifest.xml'
# '-S'
# '/store/open/CSipSimple/bin/res'
# '-S'
# '/store/open/CSipSimple/res'
# '-S'
# '/store/open/ActionBarSherlock/actionbarsherlock/bin/res'
# '-S'
# '/store/open/ActionBarSherlock/actionbarsherlock/res'
# '-I'
# '/store/open/android-sdk/platforms/android-16/android.jar'
# '-J'
# '/store/open/CSipSimple/gen'
# '--generate-dependencies'
# '-G'
# '/store/open/CSipSimple/bin/proguard.txt'



# Executing '/store/open/android-sdk/build-tools/17.0.0/aapt' with arguments:
# 'package'
# '--non-constant-id'
# '-f'
# '-m'
# '--output-text-symbols'
# '/store/open/CSipSimple/ActionBarSherlock/bin'
# '-M'
# '/store/open/CSipSimple/ActionBarSherlock/bin/AndroidManifest.xml'
# '-S'
# '/store/open/CSipSimple/ActionBarSherlock/bin/res'
# '-S'
# '/store/open/CSipSimple/ActionBarSherlock/res'
# '-I'
# '/store/open/android-sdk/platforms/android-16/android.jar'
# '-J'
# '/store/open/CSipSimple/ActionBarSherlock/gen'
# '--generate-dependencies'
# '-G'
# '/store/open/CSipSimple/ActionBarSherlock/bin/proguard.txt'
