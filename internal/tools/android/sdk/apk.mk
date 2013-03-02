APK := $(APK:%=$(SRCDIR)/%)

ifndef CERT
  CERT := cert
endif #CERT

KEYSTORE := $(or \
  $(wildcard $(SRCDIR)/.androidsdk/keystore),\
  $(wildcard $(SRCDIR)/.android/keystore),\
  $(wildcard $(smart.tooldir)/sdk/key/keystore))
KEYPASS := $(or \
  $(wildcard $(SRCDIR)/.androidsdk/keypass),\
  $(wildcard $(SRCDIR)/.android/keypass),\
  $(wildcard $(smart.tooldir)/sdk/key/keypass))
STOREPASS := $(or \
  $(wildcard $(SRCDIR)/.androidsdk/storepass),\
  $(wildcard $(SRCDIR)/.android/storepass),\
  $(wildcard $(smart.tooldir)/sdk/key/storepass))

define smart~rule
  $(OUT)/$(NAME)/_.pack:
	$$(PACK_COMMANDS) || rm -f $$@
  $(OUT)/$(NAME)/_.unsigned : $(OUT)/$(NAME)/classes.dex $(OUT)/$(NAME)/_.pack
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
