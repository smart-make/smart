define smart~rule
  $(OUT)/$(NAME)/res/.sources: | $(LIBS.local) \
    $(wildcard $(SRCDIR)/res $(SRCDIR)/assets)
	@mkdir -p $$(@D)
	$(ANDROID.aapt) package -m -J "$(OUT)/$(NAME)/res" \
	-P "$(OUT)/$(NAME)/public.xml" \
        $(addprefix -I ,"$(ANDROID_PLATFORM_LIB)") \
	$(foreach 1,$(LIBS),-I "$1") \
	$(addprefix -M ,$(wildcard $(SRCDIR)/AndroidManifest.xml)) \
	$(addprefix -A ,$(wildcard $(SRCDIR)/assets)) \
	$(addprefix -S ,$(wildcard $(SRCDIR)/res))
	@find $(OUT)/$(NAME)/res -type f -name R.java > $$@
endef #smart~rule

$(eval $(smart~rule))

define smart~rule
  $(OUT)/$(NAME)/res/.packed: | $(LIBS.local) \
    $(wildcard $(SRCDIR)/res $(SRCDIR)/assets)
	$(ANDROID.aapt) package -u -F $$@ \
        $(addprefix -I ,"$(ANDROID_PLATFORM_LIB)") \
	$(foreach 1,$(LIBS),-I "$1") $(if $(PACKAGE),-x) \
	$(addprefix -M ,$(wildcard $(SRCDIR)/AndroidManifest.xml)) \
	$(addprefix -A ,$(wildcard $(SRCDIR)/assets)) \
	$(addprefix -S ,$(wildcard $(SRCDIR)/res))

  $(OUT)/$(NAME)/_.pack: PACK_COMMANDS = cp -f "$(OUT)/$(NAME)/res/.packed" "$$@"
  $(OUT)/$(NAME)/_.pack: $(OUT)/$(NAME)/res/.packed
endef #smart~rule

$(eval $(smart~rule))

smart~rule =

$(OUT)/$(NAME)/classes/.list : | $(OUT)/$(NAME)/res/.sources
