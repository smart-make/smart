#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
KEYSTORE := $(or \
  $(wildcard $(SRCDIR)/.androidsdk/keystore),\
  $(wildcard $(SRCDIR)/.android/keystore),\
  $(wildcard $(smart.tooldir)/key/keystore))
KEYPASS := $(or \
  $(wildcard $(SRCDIR)/.androidsdk/keypass),\
  $(wildcard $(SRCDIR)/.android/keypass),\
  $(wildcard $(smart.tooldir)/key/keypass))
STOREPASS := $(or \
  $(wildcard $(SRCDIR)/.androidsdk/storepass),\
  $(wildcard $(SRCDIR)/.android/storepass),\
  $(wildcard $(smart.tooldir)/key/storepass))

$(OUT)/$(NAME)/_.pack:
	$(PACK_COMMANDS) || rm -f $@

$(OUT)/$(NAME)/_.unsigned: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/_.unsigned: out := $(OUT)/$(NAME)
$(OUT)/$(NAME)/_.unsigned: $(CLASSES.DEX) $(OUT)/$(NAME)/_.pack
	@cp -f $(out)/_.pack $@
	$(aapt) add -k $@ $< || rm -f $@

$(OUT)/$(NAME)/_.signed: cert := $(or $(CERT),cert)
$(OUT)/$(NAME)/_.signed: storepass := $(STOREPASS)
$(OUT)/$(NAME)/_.signed: keypass := $(KEYPASS)
$(OUT)/$(NAME)/_.signed: keystore := $(KEYSTORE)
$(OUT)/$(NAME)/_.signed: jarsigner := $(ANDROID.jarsigner)
$(OUT)/$(NAME)/_.signed: command = \
	$(jarsigner) -sigalg MD5withRSA -digestalg SHA1 \
	$(addprefix -keystore , $(keystore)) \
	$(if $(keypass),-keypass `cat $(keypass)`) \
	$(if $(storepass), -storepass `cat $(storepass)`) \
	$@ $(cert) || rm -f $@
$(OUT)/$(NAME)/_.signed: $(OUT)/$(NAME)/_.unsigned
	@cp -f $< $@
	$(command)

APK := $(APK:%=$(SRCDIR)/%)
$(APK): zipalign := $(ANDROID.zipalign)
$(APK): $(OUT)/$(NAME)/_.signed
	$(zipalign) -f 4 $< $@


smart~rule =

#$(OUT)/$(NAME):
