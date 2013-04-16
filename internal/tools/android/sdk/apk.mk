#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
APK := $(APK:%=$(SRCDIR)/%)

ifndef CERT
  CERT := cert
endif #CERT

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

define smart~rule
  $(OUT)/$(NAME)/_.pack:
	$$(PACK_COMMANDS) || rm -f $$@
  $(OUT)/$(NAME)/_.unsigned : $(CLASSES.DEX) $(OUT)/$(NAME)/_.pack \

	@cp -f $(OUT)/$(NAME)/_.pack $$@
	$(ANDROID.aapt) add -k $$@ $$< || rm -f $$@
endef #smart~rule

$(eval $(smart~rule))

define smart~rule
  $(OUT)/$(NAME)/_.signed: $(OUT)/$(NAME)/_.unsigned
	@cp -f $$< $$@
	$(ANDROID.jarsigner) -sigalg MD5withRSA -digestalg SHA1 \
	$(addprefix -keystore , $(KEYSTORE))\
	$(if $(KEYPASS),-keypass `cat $(KEYPASS)`)\
	$(if $(STOREPASS), -storepass `cat $(STOREPASS)`)\
	$$@ $(CERT) || rm -f $$@
endef #smart~rule

$(eval $(smart~rule))

smart~rule =

$(APK) : $(OUT)/$(NAME)/_.signed
	$(ANDROID.zipalign) -f 4 $< $@
