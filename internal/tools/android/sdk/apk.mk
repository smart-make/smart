APK := $(APK:%=$(SRCDIR)/%)

CERT := cert
KEYSTORE := $(wildcard $(SRCDIR)/.androidsdk/keystore)
KEYPASS := $(wildcard $(SRCDIR)/.androidsdk/keypass)
STOREPASS := $(wildcard $(SRCDIR)/.androidsdk/storepass)

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
