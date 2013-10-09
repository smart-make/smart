#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

## Helper for getting variable of $(smart~m)
smart~var = $(call smart.get,$(smart~m),$1)

PLATFORM := $(or $(PLATFORM),android-14)
$(foreach 1,$(SUPPORTS),$(eval LIBS += $(ANDROID.root)/android-compatibility/$1/android-support-$1.jar))

ifeq ($(shell expr $(PLATFORM:android-%=%) '<' 15),yes)
  LIBS += $(ANDROID_ROOT)/tools/support/annotations.jar
endif

SRC.required :=
RES.proguard :=
RES.crunched :=
LIBS.path :=
LIBS.jar := $(filter %.jar,$(LIBS))
LIBS.native := $(filter %.so,$(LIBS))
LIBS.native_list := $(filter %.native,$(LIBS))
ifneq ($(wildcard $(SRCDIR)/libs),)
  LIBS.jar += $(wildcard $(PWD)/$(SRCDIR)/libs/*.jar)
  LIBS.native += $(call smart.find,$(SRCDIR)/libs,%.so %/gdbserver %/gdb.setup)
endif

define smart~use
$(eval \
  ifeq ($(call smart~var,TOOL),$(TOOL))
    ifneq ($(call smart~var,LIBRARY),)
      ifeq ($$(filter $(OUT)/$(call smart~var,NAME)/classes.jar,$$(LIBS.jar)),)
        #LIBS.jar += $(OUT)/$(call smart~var,NAME)/classes.jar
      endif
      ifeq ($$(filter $(OUT)/$(call smart~var,NAME)/classes,$$(LIBS.path)),)
        LIBS.path += $(OUT)/$(call smart~var,NAME)/classes
      endif
      RES.proguard += ../$(call smart~var,NAME)/res.proguard
      RES.crunched += $(OUT)/$(call smart~var,NAME)/res
      RES += $(call smart~var,SRCDIR)/res
      SRC.required += $(call smart~var,SRCDIR)/src
      ifneq ($(wildcard $(call smart~var,SRCDIR)/AndroidManifest.xml),)
        EXTRA_PACKAGES := $(if $(EXTRA_PACKAGES),$(EXTRA_PACKAGES):)$$(shell awk -f $(smart.tooldir)/extract-package-name.awk $(call smart~var,SRCDIR)/AndroidManifest.xml)
      endif
    endif
  endif
 )$(foreach smart~m,$(call smart~var,REQUIRES),$(call smart~use))
endef #smart~use
$(foreach smart~m,$(REQUIRES),$(smart~use))

#$(warning $(NAME): $(LIBS), $(REQUIRES))
#$(warning $(NAME): $(LIBS.jar))
#$(warning $(NAME): $(LIBS.path))

#CLASSPATH := $(ANDROID_PLATFORM_LIB):$(CLASSPATH)
$(foreach 1,$(LIBS.jar),$(eval CLASSPATH := $(CLASSPATH):$1))
$(foreach 1,$(LIBS.path),$(eval CLASSPATH := $(CLASSPATH):$1))
CLASSPATH := $(CLASSPATH::%=%)

# LIBS.jar includes the list of .jar libs.
$(OUT)/$(NAME)/.classpath: bootclass := $(ANDROID_PLATFORM_LIB)
$(OUT)/$(NAME)/.classpath: classpath := $(CLASSPATH)
$(OUT)/$(NAME)/.classpath: $(SCRIPT)
$(OUT)/$(NAME)/.classpath: $(LIBS.path:%/classes=%/.classes)
$(OUT)/$(NAME)/.classpath: $(LIBS.jar) $(LIBS.path:%/classes=%/.classes)
	@mkdir -p $(@D)
	@echo '-bootclasspath "$(bootclass)"' > $@
	@echo '-cp "$(classpath)"' >> $@

# $(modules-get-list), __ndk_modules, __ndk_import_list, __ndk_import_dirs
# $(foreach 1,$(USE_MODULES),$(warning $1))

## Java sources
ifndef SOURCES
  SOURCES := $(call smart.find,$(SRCDIR)/src,%.java %.aidl)
endif #SOURCES

SOURCES.aidl := $(filter %.aidl,$(SOURCES))
SOURCES.java := $(filter %.java,$(SOURCES))

ifneq ($(or $(LIBS.native),$(LIBS.native_list)),)
  include $(smart.tooldir)/native.mk
endif #LIBS.native or LIBS.native_list

ifdef PACKAGE
smart~package~out := $(OUT)/$(NAME)/sources/$(subst .,/,$(PACKAGE))
smart~buildconfig.java := $(smart~package~out)/BuildConfig.java
$(OUT)/$(NAME)/sources: $(smart~buildconfig.java)
$(smart~buildconfig.java): debug := $(DEBUG)
$(smart~buildconfig.java): package := $(PACKAGE)
$(smart~buildconfig.java): 
	@echo "Gen BuildConfig.java for '$(package)'..."
	@mkdir -p "$(@D)"
	@echo "/** Automatically generated file. DO NOT MODIFY */" > $@
	@echo "package $(package);" >> $@
	@echo "public final class BuildConfig {" >> $@
	@echo "    public final static boolean DEBUG = $(if $(debug),true,false);" >> $@
	@echo "}" >> $@
else
smart~buildconfig.java :=
endif # PACKAGE

ifdef SOURCES.aidl
$(OUT)/$(NAME)/sources: $(OUT)/$(NAME)/sources/.aidl
$(OUT)/$(NAME)/sources/.aidl: aidl := $(ANDROID.aidl)
$(OUT)/$(NAME)/sources/.aidl: incs := $(foreach s,$(SRCDIR)/src $(SRC.required),-I"$s")
$(OUT)/$(NAME)/sources/.aidl: preprocess := $(ANDROID_PREPROCESS_IMPORT)
$(OUT)/$(NAME)/sources/.aidl: out := $(OUT)/$(NAME)
$(OUT)/$(NAME)/sources/.aidl: $(SOURCES.aidl)
$(OUT)/$(NAME)/sources/.aidl:
	@echo "Compile aidl.."
	@mkdir -p "$(@D)"
	@for f in $^ ; do echo "aidl $$f"; \
	if grep "^parcelable\s.*;" $$f > /dev/null ; then true; else \
	$(aidl) $(incs) -p"$(preprocess)" -o"$(out)/sources" -b $$f ; fi ; done
	@touch $@
endif # SOURCES.aidl

$(OUT)/$(NAME)/.sources: package := $(PACKAGE)
$(OUT)/$(NAME)/.sources: sources := $(SOURCES.java)
$(OUT)/$(NAME)/.sources: $(SOURCES.java) 
$(OUT)/$(NAME)/.sources: $(OUT)/$(NAME)/sources

$(OUT)/$(NAME)/.classes: debug := $(DEBUG)
$(OUT)/$(NAME)/.classes: package := $(PACKAGE)
$(OUT)/$(NAME)/.classes: classpath := $(OUT)/$(NAME)/.classpath
$(OUT)/$(NAME)/.classes: sourcepath := $(OUT)/$(NAME)/sources
$(OUT)/$(NAME)/.classes: sources := $(SOURCES.java)
$(OUT)/$(NAME)/.classes: out := $(OUT)/$(NAME)/classes
$(OUT)/$(NAME)/.classes: command = \
	javac -d $(out) $(if $(debug),-g) \
	-encoding "UTF-8" -source 1.5 -target 1.5 \
	-sourcepath "$(sourcepath)" \
        "@$(classpath)" "@$(@D)/.sources"
$(OUT)/$(NAME)/.classes: $(OUT)/$(NAME)/.classpath
$(OUT)/$(NAME)/.classes: $(OUT)/$(NAME)/.sources
$(OUT)/$(NAME)/.classes:
	@rm -f $(@D)/classes.{dex,jar}
	@mkdir -p $(out)
	@echo "Compiling sources for '$(package)'..."
	@if [ "0 $(@D)/.sources" != "`wc -l $(@D)/.sources`" ]; then $(command); fi
	@find $(out) -type f -name '*.class' -print > $@

ifdef LIBRARY
  APK :=
  include $(smart.tooldir)/library.mk
  #module-$(SCRIPT): $(OUT)/$(NAME)
  #modules: module-$(SCRIPT)
  module-$(SCRIPT): name := $(NAME) ; @echo $(name)
endif #LIBRARY

ifdef APK
  include $(smart.tooldir)/apk.mk
  module-$(SCRIPT): $(APK)
  modules: module-$(SCRIPT)
  $(OUT)/$(NAME)/.install: apk := $(APK)
  $(OUT)/$(NAME)/.install: package := $(PACKAGE)
  $(OUT)/$(NAME)/.install: adb_environment := $(addprefix ANDROID_SERIAL=,$(DEVICE))
  $(OUT)/$(NAME)/.install: $(APK)
	$(adb_environment) adb install -r $(apk) && touch $@
  install-$(NAME): $(OUT)/$(NAME)/.install
  uninstall-$(NAME): package := $(PACKAGE)
  uninstall-$(NAME): install_stamp_file := $(OUT)/$(NAME)/.install
  uninstall-$(NAME): adb_environment := $(addprefix ANDROID_SERIAL=,$(DEVICE))
  uninstall-$(NAME):
	$(adb_environment) adb uninstall $(package) && sleep 1
	@rm -f $(install_stamp_file)
  run-$(NAME): package := $(PACKAGE)
  run-$(NAME): launch := $(or $(LAUNCH),.Main)
  run-$(NAME): adb_environment := $(addprefix ANDROID_SERIAL=,$(DEVICE))
  run-$(NAME): install-$(NAME)
	$(adb_environment) adb shell am start -a MAIN -n $(package)/$(launch)
endif #APK
