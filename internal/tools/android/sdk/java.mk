#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifneq ($(or $(wildcard $(SRCDIR)/AndroidManifest.xml),$(wildcard $(SRCDIR)/res),$(RES)),)
smart~r.java := $(OUT)/$(NAME)/sources/R.java.d
smart~r.java += $(foreach p,$(PACKAGE) $(subst :, ,$(EXTRA_PACKAGES)),$(OUT)/$(NAME)/sources/$(subst .,/,$p)/R.java)
ifneq ($(wildcard $(OUT)/$(NAME)/sources/R.java.d),)
  -include $(OUT)/$(NAME)/sources/R.java.d
endif
#$(warning $(EXTRA_PACKAGES))
#$(warning $(smart~r.java))
$(OUT)/$(NAME)/res.proguard: $(smart~r.java)
$(smart~r.java): aapt := $(ANDROID.aapt)
$(smart~r.java): package := $(R_PACKAGE)
$(smart~r.java): manifest := $(wildcard $(SRCDIR)/AndroidManifest.xml)
$(smart~r.java): assets := $(wildcard $(SRCDIR)/assets) $(ASSETS)
$(smart~r.java): reses := $(wildcard $(SRCDIR)/res) $(RES)
$(smart~r.java): libs := $(LIBS.jar) $(ANDROID_PLATFORM_LIB)
$(smart~r.java): extra-packages := $(EXTRA_PACKAGES)
$(smart~r.java): out := $(OUT)/$(NAME)
$(smart~r.java): command = \
	$(aapt) package -f -m \
	-J "$(out)/sources" \
	-P "$(out)/public.xml" \
	-G "$(out)/res.proguard" \
	$(addprefix --extra-packages ,$(extra-packages)) \
	$(addprefix --custom-package ,$(package)) \
	$(addprefix -M ,$(manifest)) \
	$(foreach 1,$(assets),-A "$1") \
	$(foreach 1,$(reses),-S "$1") \
	$(foreach 1,$(libs),-I "$1") \
	--output-text-symbols "$(out)" \
	--generate-dependencies \
	--auto-add-overlay
$(smart~r.java): $(LIBS.jar)
$(smart~r.java): $(SRCDIR)/AndroidManifest.xml
	@echo "Gen R.java..."
	@mkdir -p "$(@D)"
	$(command)
endif ## has res/assests/AndroidMenifest.xml

$(OUT)/$(NAME)/sources/.aidl: aidl := $(ANDROID.aidl)
$(OUT)/$(NAME)/sources/.aidl: src := $(SRCDIR)/src
$(OUT)/$(NAME)/sources/.aidl: preprocess := $(ANDROID_PREPROCESS_IMPORT)
$(OUT)/$(NAME)/sources/.aidl: out := $(OUT)/$(NAME)
$(OUT)/$(NAME)/sources/.aidl: $(SOURCES.aidl)
$(OUT)/$(NAME)/sources/.aidl:
	@echo "Compile aidl.."
	@mkdir -p "$(@D)"
	@for f in $^ ; do echo "aidl $$f"; \
	if grep "^parcelable\s.*;" $$f > /dev/null ; then true; else \
	$(aidl) -I"$(src)" -p"$(preprocess)" -o"$(out)/sources" -b $$f ; fi ; done
	@touch $@

$(OUT)/$(NAME)/.sources: sources := $(SOURCES.java)
$(OUT)/$(NAME)/.sources: out := $(OUT)/$(NAME)
$(OUT)/$(NAME)/.sources: $(SOURCES.java) 
$(OUT)/$(NAME)/.sources: $(smart~r.java)
$(OUT)/$(NAME)/.sources: $(OUT)/$(NAME)/sources/.aidl
$(OUT)/$(NAME)/.sources:
	@echo "Gen source list.."
	@mkdir -p $(@D) && echo -n > $@
	@for f in $(sources) ; do echo $$f >> $@ ; done
	@find "$(out)/sources" -type f -name '*.java' >> $@

# LIBS.jar includes the list of .jar libs.
$(OUT)/$(NAME)/.classpath: classpath := $(CLASSPATH)
$(OUT)/$(NAME)/.classpath: $(LIBS.jar)
	@mkdir -p $(@D) && echo '-cp "$(classpath)"' > $@

$(OUT)/$(NAME)/.classes: bootclass := $(ANDROID_PLATFORM_LIB)
$(OUT)/$(NAME)/.classes: classpath := $(OUT)/$(NAME)/.classpath
$(OUT)/$(NAME)/.classes: sources := $(OUT)/$(NAME)/.sources
$(OUT)/$(NAME)/.classes: out := $(OUT)/$(NAME)
$(OUT)/$(NAME)/.classes: command = \
	javac -d $(out)/classes $(if $(DEBUG),-g) \
	-encoding "UTF-8" -source 1.5 -target 1.5 \
        -bootclasspath "$(bootclass)" "@$(classpath)" "@$(sources)"
$(OUT)/$(NAME)/.classes: $(OUT)/$(NAME)/.classpath
$(OUT)/$(NAME)/.classes: $(OUT)/$(NAME)/.sources
$(OUT)/$(NAME)/.classes: $(LIBS.jar)
	@rm -rf $(out)/classes $(out)/classes.dex
	@mkdir -p $(out)/classes
	$(command)
	@cd $(out)/classes && find . -type f -name '*.class' > ../$(@F)

ifneq ($(SOURCES.java),)
  ifdef PROGUARD
    include $(smart.tooldir)/proguard.mk
    $(OUT)/$(NAME)/classes.dex: dex_dest := $(OUT)/$(NAME)
    $(OUT)/$(NAME)/classes.dex: dex_input := classes-obfuscated.jar
    $(OUT)/$(NAME)/classes.dex: dex_output := classes.dex
    $(OUT)/$(NAME)/classes.dex: $(OUT)/$(NAME)/classes-obfuscated.jar
  else
    $(OUT)/$(NAME)/classes.dex: dex_dest := $(OUT)/$(NAME)/classes
    $(OUT)/$(NAME)/classes.dex: dex_input := .
    $(OUT)/$(NAME)/classes.dex: dex_output := ../classes.dex
    $(OUT)/$(NAME)/classes.dex: $(OUT)/$(NAME)/.classes
  endif #PROGUARD
  $(OUT)/$(NAME)/classes.dex: dx := $(ANDROID.dx)
  $(OUT)/$(NAME)/classes.dex: out := $(OUT)/$(NAME)
  $(OUT)/$(NAME)/classes.dex: apk := $(APK)
  $(OUT)/$(NAME)/classes.dex: libs := $(LIBS.jar:$(OUT)/%=$(TOP)/$(OUT)/%)
  $(OUT)/$(NAME)/classes.dex: command = \
	$(dx) $(if $(findstring windows,$(sm.os.name)),,-JXms16M -JXmx1536M)\
	--dex --output $(dex_output) $(libs) $(dex_input)
  $(OUT)/$(NAME)/classes.dex:
	@rm -vf $(apk) $(out)/_.unsigned $(out)/_.signed
	cd $(dex_dest) && $(command)

  CLASSES.DEX := $(OUT)/$(NAME)/classes.dex
else
  CLASSES.DEX :=
endif




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
