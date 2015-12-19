#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

V := $(if $(DEBUG),debug,release)

## Helper for getting variable of $(smart~m)
smart~var = $(call smart.get,$(smart~m),$1)

PLATFORM := $(or $(PLATFORM),android-14)
$(foreach 1,$(SUPPORTS),$(eval LIBS += $(ANDROID.root)/android-compatibility/$1/android-support-$1.jar))

smart~platform~lt~15 := $(shell expr $(PLATFORM:android-%=%) '<' 15)
ifeq ($(smart~platform~lt~15),1)
  smart~platform~lt~15 := yes
endif
ifeq ($(smart~platform~lt~15),yes)
  LIBS += $(ANDROID_ROOT)/tools/support/annotations.jar
endif

SRC.required :=
RES.proguard :=
RES.crunched :=
LIBS.classes :=
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
      #LIBS.jar += $(OUT)/$(call smart~var,NAME)/$V/classes.jar
      LIBS.classes += $(OUT)/$(call smart~var,NAME)/$V/classes
      RES.proguard += ../$(call smart~var,NAME)/res.proguard
      RES.crunched += $(OUT)/$(call smart~var,NAME)/$V/res
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

$(call smart~unique,LIBS.native)
$(call smart~unique,LIBS.native_list)
$(call smart~unique,LIBS.classes)
$(call smart~unique,LIBS.jar)
$(call smart~unique,RES.proguard)
$(call smart~unique,RES.crunched)
$(call smart~unique,RES)

#$(warning $(NAME): $(LIBS), $(REQUIRES))
#$(warning $(NAME): $(LIBS.jar))
#$(warning $(NAME): $(LIBS.classes))

#CLASSPATH := $(ANDROID_PLATFORM_LIB):$(CLASSPATH)
$(foreach 1,$(LIBS.jar),$(eval CLASSPATH := $(CLASSPATH):$1))
$(foreach 1,$(LIBS.classes),$(eval CLASSPATH := $(CLASSPATH):$1))
CLASSPATH := $(CLASSPATH::%=%)

# LIBS.jar includes the list of .jar libs.
$(OUT)/$(NAME)/$V/.classpath: bootclass := $(ANDROID_PLATFORM_LIB)
$(OUT)/$(NAME)/$V/.classpath: classpath := $(CLASSPATH)
$(OUT)/$(NAME)/$V/.classpath: $(LIBS.classes:%/classes=%/.classes)
$(OUT)/$(NAME)/$V/.classpath: $(LIBS.jar) $(LIBS.classes:%/classes=%/.classes)
$(OUT)/$(NAME)/$V/.classpath: $(SCRIPT)
$(OUT)/$(NAME)/$V/.classpath:
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
smart~package~out := $(OUT)/$(NAME)/$V/sources/$(subst .,/,$(PACKAGE))
smart~buildconfig.java := $(smart~package~out)/BuildConfig.java
$(OUT)/$(NAME)/$V/.sources: $(smart~buildconfig.java)
$(smart~buildconfig.java): debug := $(DEBUG)
$(smart~buildconfig.java): package := $(PACKAGE)
$(smart~buildconfig.java): buildconfig := $(smart.tooldir)/BuildConfig.in
$(smart~buildconfig.java): $(smart.tooldir)/BuildConfig.in
$(smart~buildconfig.java): 
	@echo "Gen BuildConfig.java for '$(package)'..." && mkdir -p "$(@D)"
	@m4 -D__PACKAGE__=$(package) -D__DEBUG__=$(if $(debug),true,false) \
	$(buildconfig) > $@
else
smart~buildconfig.java :=
endif # PACKAGE


ifneq ($(wildcard $(OUT)/$(NAME)/$V/sources/R.java.d),)
  -include $(OUT)/$(NAME)/$V/sources/R.java.d
endif
smart~r.java := $(OUT)/$(NAME)/$V/sources/R.java.d
smart~r.java += $(foreach p,$(PACKAGE)\
  $(if $(LIBRARY),,$(subst :, ,$(EXTRA_PACKAGES))),\
  $(OUT)/$(NAME)/$V/sources/$(subst .,/,$p)/R.java)

$(call smart~unique,smart~r.java)
$(OUT)/$(NAME)/$V/res.proguard: $(filter-out %/R.java.d,$(smart~r.java))
$(OUT)/$(NAME)/$V/.sources: $(filter-out %/R.java.d,$(smart~r.java))
$(smart~r.java): aapt := $(ANDROID.aapt)
$(smart~r.java): package := $(PACKAGE)
$(smart~r.java): r-package := $(R_PACKAGE)
$(smart~r.java): manifest := $(wildcard $(SRCDIR)/AndroidManifest.xml)
$(smart~r.java): assets := $(wildcard $(SRCDIR)/assets) $(ASSETS)
$(smart~r.java): reses := $(wildcard $(SRCDIR)/res) $(RES)
$(smart~r.java): libs := $(ANDROID_PLATFORM_LIB) $(LIBS.jar) $(LIBS.classes)
$(smart~r.java): out := $(OUT)/$(NAME)/$V
$(smart~r.java): $(LIBS.jar)
#$(smart~r.java): $(call smart.find,$(SRCDIR)/res,%.xml %.png %.jpg)
#$(smart~r.java): $(call smart.find,$(SRCDIR)/assets,,%~)
$(smart~r.java): $(SRCDIR)/AndroidManifest.xml
$(smart~r.java):
	@echo "Generate R.java for '$(package)'..."
	@mkdir -p "$(@D)"
	@$(command)

#$(warning $(NAME): $(OUT)/$(NAME)/$V/.sources; $(smart~r.java))
#$(warning $(NAME): $(LIBS.jar))
#$(warning $(NAME): $(filter-out %/R.java.d,$(smart~r.java)))

ifdef SOURCES.aidl
$(OUT)/$(NAME)/$V/.sources: $(OUT)/$(NAME)/$V/sources/.aidl
$(OUT)/$(NAME)/$V/sources/.aidl: aidl := $(ANDROID.aidl)
$(OUT)/$(NAME)/$V/sources/.aidl: incs := $(foreach s,$(SRCDIR)/src $(SRC.required),-I"$s")
$(OUT)/$(NAME)/$V/sources/.aidl: preprocess := $(ANDROID_PREPROCESS_IMPORT)
$(OUT)/$(NAME)/$V/sources/.aidl: out := $(OUT)/$(NAME)/$V
$(OUT)/$(NAME)/$V/sources/.aidl: $(SOURCES.aidl)
$(OUT)/$(NAME)/$V/sources/.aidl:
	@echo "Compile aidl.."
	@mkdir -p "$(@D)"
	@for f in $^ ; do echo "aidl $$f"; \
	if grep "^parcelable\s.*;" $$f > /dev/null ; then true; else \
	$(aidl) $(incs) -p"$(preprocess)" -o"$(out)/sources" -b $$f ; fi ; done
	@touch $@
endif # SOURCES.aidl

$(OUT)/$(NAME)/$V/.sources: package := $(PACKAGE)
$(OUT)/$(NAME)/$V/.sources: sources := $(SOURCES.java)
$(OUT)/$(NAME)/$V/.sources: $(SOURCES.java)
$(OUT)/$(NAME)/$V/.sources:
	@echo "Prepare source list for '$(package)'.."
	@echo "$(sources)"
	@mkdir -p $(@D) && echo -n > $@
	@(for f in $(sources) ; do echo $$f ; done) >> $@
	@find "$(@D)/sources" -type f -name '*.java' >> $@

$(OUT)/$(NAME)/$V/.classes: debug := $(DEBUG)
$(OUT)/$(NAME)/$V/.classes: package := $(PACKAGE)
$(OUT)/$(NAME)/$V/.classes: classpath := $(OUT)/$(NAME)/$V/.classpath
$(OUT)/$(NAME)/$V/.classes: sourcepath := $(OUT)/$(NAME)/$V/sources
$(OUT)/$(NAME)/$V/.classes: sources := $(SOURCES.java)
$(OUT)/$(NAME)/$V/.classes: out := $(OUT)/$(NAME)/$V/classes
$(OUT)/$(NAME)/$V/.classes: command = \
	javac -d $(out) $(if $(debug),-g) -Xlint:unchecked \
	-encoding "UTF-8" -source 1.5 -target 1.5 \
	-sourcepath "$(sourcepath)" \
        "@$(classpath)" "@$(@D)/.sources"
$(OUT)/$(NAME)/$V/.classes: $(OUT)/$(NAME)/$V/.classpath
$(OUT)/$(NAME)/$V/.classes: $(OUT)/$(NAME)/$V/.sources
$(OUT)/$(NAME)/$V/.classes:
	@rm -f $(@D)/classes.{dex,jar}
	@mkdir -p $(out)
	@echo "Compile sources for '$(package)'..."
	@if [ "0 $(@D)/.sources" != "`wc -l $(@D)/.sources`" ]; then $(command); fi
	@find $(out) -type f -name '*.class' -print > $@

ifdef LIBRARY
  APK :=
  include $(smart.tooldir)/library.mk
  module-$(SCRIPT): name := $(NAME) ; @echo $(name)
endif #LIBRARY

ifdef APK
  include $(smart.tooldir)/apk.mk
  module-$(SCRIPT): $(APK)
  modules: module-$(SCRIPT)
  $(OUT)/$(NAME)/$V/.install: apk := $(APK)
  $(OUT)/$(NAME)/$V/.install: package := $(PACKAGE)
  $(OUT)/$(NAME)/$V/.install: adb_environment := $(addprefix ANDROID_SERIAL=,$(DEVICE))
  $(OUT)/$(NAME)/$V/.install: $(APK)
	$(adb_environment) adb install -r $(apk) && touch $@
  install-$(NAME): $(OUT)/$(NAME)/$V/.install
  uninstall-$(NAME): package := $(PACKAGE)
  uninstall-$(NAME): install_stamp_file := $(OUT)/$(NAME)/$V/.install
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
