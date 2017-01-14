#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME), $(SCRIPT), $(SRCDIR))

$(smart~r.java): extra-packages := $(EXTRA_PACKAGES)
$(smart~r.java): command = \
	$(aapt) package -f -m \
	-J "$(out)/sources" \
	-P "$(out)/public.xml" \
	-G "$(out)/res.proguard" \
	$(addprefix --extra-packages ,$(extra-packages)) \
	$(addprefix --custom-package ,$(r-package)) \
	$(addprefix -M ,$(manifest)) \
	$(foreach 1,$(assets),-A "$1") \
	$(foreach 1,$(reses),-S "$1") \
	$(foreach 1,$(libs),-I "$1") \
	--output-text-symbols "$(out)" \
	--generate-dependencies \
	--auto-add-overlay

smart~debug~tag~file := $(OUT)/$(NAME)/$V/.debug.$(if $(DEBUG),true,false)
smart~debug~tag~file~neg := $(OUT)/$(NAME)/$V/.debug.$(if $(DEBUG),false,true)

$(smart~buildconfig.java): $(smart~debug~tag~file)
$(smart~debug~tag~file): debug := $(DEBUG)
$(smart~debug~tag~file): buildconfig := $(smart~buildconfig.java)
$(smart~debug~tag~file): negative := $(smart~debug~tag~file~neg)
$(smart~debug~tag~file):
	@rm -f $(negative) $(buildconfig)
	@touch $@

ifneq ($(SOURCES.java),)
  ifdef PROGUARD
    include $(smart.tooldir)/proguard.mk
    $(OUT)/$(NAME)/$V/classes.dex: dex_dest := $(OUT)/$(NAME)/$V
    $(OUT)/$(NAME)/$V/classes.dex: dex_input := classes-obfuscated.jar
    $(OUT)/$(NAME)/$V/classes.dex: dex_output := classes.dex
    $(OUT)/$(NAME)/$V/classes.dex: $(OUT)/$(NAME)/$V/classes-obfuscated.jar
  else
    $(OUT)/$(NAME)/$V/classes.dex: dex_dest := $(OUT)/$(NAME)/$V/classes
    $(OUT)/$(NAME)/$V/classes.dex: dex_input := .
    $(OUT)/$(NAME)/$V/classes.dex: dex_output := ../classes.dex
    $(OUT)/$(NAME)/$V/classes.dex: $(OUT)/$(NAME)/$V/.classes
  endif #PROGUARD
  $(OUT)/$(NAME)/$V/classes.dex: dx := $(ANDROID.dx)
  $(OUT)/$(NAME)/$V/classes.dex: out := $(OUT)/$(NAME)/$V
  $(OUT)/$(NAME)/$V/classes.dex: apk := $(APK)
  $(OUT)/$(NAME)/$V/classes.dex: libs := $(LIBS.jar:$(OUT)/%=$(TOP)/$(OUT)/%)
  $(OUT)/$(NAME)/$V/classes.dex: libs += $(LIBS.classes:$(OUT)/%=$(TOP)/$(OUT)/%)
  $(OUT)/$(NAME)/$V/classes.dex: command = \
	$(dx) $(if $(findstring windows,$(sm.os.name)),,-JXms16M -JXmx1536M)\
	--dex --output $(dex_output) $(libs) $(dex_input)
  $(OUT)/$(NAME)/$V/classes.dex: $(LIBS.classes:%=%.deleted)
  $(OUT)/$(NAME)/$V/classes.dex:
	@rm -vf $(apk) $(out)/_.unsigned $(out)/_.signed
	@echo "dx $(dex_dest)..."
	@cd $(dex_dest) && $(command)

  CLASSES.DEX := $(OUT)/$(NAME)/$V/classes.dex
else
  CLASSES.DEX :=
endif

# $(RES.crunched) 
# $(if $(PACKAGE),-x)
$(OUT)/$(NAME)/$V/_.pack: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/$V/_.pack: reses := $(wildcard $(SRCDIR)/res) $(RES)
$(OUT)/$(NAME)/$V/_.pack: assets := $(wildcard $(SRCDIR)/assets) $(ASSETS)
$(OUT)/$(NAME)/$V/_.pack: manifest := $(wildcard $(SRCDIR)/AndroidManifest.xml)
$(OUT)/$(NAME)/$V/_.pack: libs := $(ANDROID_PLATFORM_LIB) $(LIBS.jar)
$(OUT)/$(NAME)/$V/_.pack: classes := $(CLASSES.DEX)
$(OUT)/$(NAME)/$V/_.pack: command = \
	$(aapt) package -f -F $@ \
	$(addprefix -M ,"$(manifest)") \
	$(foreach 1,$(libs),-I "$1") \
	$(foreach 1,$(reses),-S "$1") \
	$(foreach 1,$(assets),-A "$1") \
	$(if $(DEBUG),--debug-mode) \
	--auto-add-overlay \

#	--no-crunch
$(OUT)/$(NAME)/$V/_.pack: $(LIBS.jar)
$(OUT)/$(NAME)/$V/_.pack: $(CLASSES.DEX)
$(OUT)/$(NAME)/$V/_.pack: $(SRCDIR)/AndroidManifest.xml
$(OUT)/$(NAME)/$V/_.pack:
	@mkdir -p $(@D)
	@echo "Packing resources..."
	$(command)
	@echo "Packing native libraries..."
	@$(pack_libs)
	@echo "Packing classes..."
	@$(aapt) add -k $@ $(classes)

$(OUT)/$(NAME)/$V/_.signed: storepass := $(or \
	$(wildcard $(SRCDIR)/.androidsdk/storepass),\
	$(wildcard $(SRCDIR)/.android/storepass),\
	$(wildcard $(smart.tooldir)/key/storepass))
$(OUT)/$(NAME)/$V/_.signed: keypass := $(or \
	$(wildcard $(SRCDIR)/.androidsdk/keypass),\
	$(wildcard $(SRCDIR)/.android/keypass),\
	$(wildcard $(smart.tooldir)/key/keypass))
$(OUT)/$(NAME)/$V/_.signed: keystore := $(or \
	$(wildcard $(SRCDIR)/.androidsdk/keystore),\
	$(wildcard $(SRCDIR)/.android/keystore),\
	$(wildcard $(smart.tooldir)/key/keystore))
$(OUT)/$(NAME)/$V/_.signed: cert := $(or $(CERT),cert)
$(OUT)/$(NAME)/$V/_.signed: jarsigner := $(ANDROID.jarsigner)
$(OUT)/$(NAME)/$V/_.signed: command = \
	$(jarsigner) -sigalg MD5withRSA -digestalg SHA1 \
	$(addprefix -keystore , $(keystore)) \
	$(if $(keypass),-keypass `cat $(keypass)`) \
	$(if $(storepass), -storepass `cat $(storepass)`) \
	$@ $(cert)
$(OUT)/$(NAME)/$V/_.signed: $(OUT)/$(NAME)/$V/_.pack
	@cp -f $< $@
	@echo "Signing package..."
	@$(command)

APK := $(APK:%=$(SRCDIR)/%)
$(APK): zipalign := $(ANDROID.zipalign)
$(APK): $(OUT)/$(NAME)/$V/_.signed
	@echo "Aligning $@..."
	@$(zipalign) -f 4 $< $@










##################################################
## Crunch
# Executing '/store/open/android-sdk/build-tools/17.0.0/aapt' with arguments:
# 'crunch'
# '-v'
# '-S'
# '/store/open/ActionBarSherlock/actionbarsherlock/res'
# '-C'
# '/store/open/ActionBarSherlock/actionbarsherlock/bin/res'

## Generate R.java
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


## Build library
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

## Build apk..
# Executing '/store/open/android-sdk/build-tools/17.0.0/aapt' with arguments:
# 'package'
# '--no-crunch'
# '-f'
# '--debug-mode'
# '--auto-add-overlay'
# '-M'
# '/w/android/sandbox/NavigationDrawer/bin/AndroidManifest.xml'
# '-S'
# '/w/android/sandbox/NavigationDrawer/bin/res'
# '-S'
# '/w/android/sandbox/NavigationDrawer/res'
# '-S'
# '/w/android/sandbox/NavigationDrawer/v7-appcompat/bin/res'
# '-S'
# '/w/android/sandbox/NavigationDrawer/v7-appcompat/res'
# '-I'
# '/store/open/android-sdk/platforms/android-14/android.jar'
# '-F'
# '/w/android/sandbox/NavigationDrawer/bin/MainActivity.ap_'
# '--generate-dependencies'
