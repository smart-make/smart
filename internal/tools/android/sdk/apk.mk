#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

$(OUT)/$(NAME)/_.pack: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/_.pack: reses := $(wildcard $(SRCDIR)/res) $(RES)
$(OUT)/$(NAME)/_.pack: assets := $(wildcard $(SRCDIR)/assets) $(ASSETS)
$(OUT)/$(NAME)/_.pack: manifest := $(wildcard $(SRCDIR)/AndroidManifest.xml)
$(OUT)/$(NAME)/_.pack: libs := $(LIBS.jar) $(ANDROID_PLATFORM_LIB)
$(OUT)/$(NAME)/_.pack: classes := $(CLASSES.DEX)
$(OUT)/$(NAME)/_.pack: package := $(PACKAGE)
$(OUT)/$(NAME)/_.pack: command = \
	$(aapt) package -u -F $@ $(if $(package),-x) \
	$(addprefix -M ,"$(manifest)") \
	$(foreach 1,$(libs),-I "$1") \
	$(foreach 1,$(reses),-S "$1") \
	$(foreach 1,$(assets),-A "$1") \
	--auto-add-overlay
$(OUT)/$(NAME)/_.pack: $(LIBS.jar)
$(OUT)/$(NAME)/_.pack: $(CLASSES.DEX)
$(OUT)/$(NAME)/_.pack:
	@mkdir -p $(@D)
	$(command)
	$(pack_libs)
	$(aapt) add -k $@ $(classes)

$(OUT)/$(NAME)/_.signed: storepass := $(or \
	$(wildcard $(SRCDIR)/.androidsdk/storepass),\
	$(wildcard $(SRCDIR)/.android/storepass),\
	$(wildcard $(smart.tooldir)/key/storepass))
$(OUT)/$(NAME)/_.signed: keypass := $(or \
	$(wildcard $(SRCDIR)/.androidsdk/keypass),\
	$(wildcard $(SRCDIR)/.android/keypass),\
	$(wildcard $(smart.tooldir)/key/keypass))
$(OUT)/$(NAME)/_.signed: keystore := $(or \
	$(wildcard $(SRCDIR)/.androidsdk/keystore),\
	$(wildcard $(SRCDIR)/.android/keystore),\
	$(wildcard $(smart.tooldir)/key/keystore))
$(OUT)/$(NAME)/_.signed: cert := $(or $(CERT),cert)
$(OUT)/$(NAME)/_.signed: jarsigner := $(ANDROID.jarsigner)
$(OUT)/$(NAME)/_.signed: command = \
	$(jarsigner) -sigalg MD5withRSA -digestalg SHA1 \
	$(addprefix -keystore , $(keystore)) \
	$(if $(keypass),-keypass `cat $(keypass)`) \
	$(if $(storepass), -storepass `cat $(storepass)`) \
	$@ $(cert)
$(OUT)/$(NAME)/_.signed: $(OUT)/$(NAME)/_.pack
	@cp -f $< $@
	$(command)

APK := $(APK:%=$(SRCDIR)/%)
$(APK): zipalign := $(ANDROID.zipalign)
$(APK): $(OUT)/$(NAME)/_.signed
	$(zipalign) -f 4 $< $@
