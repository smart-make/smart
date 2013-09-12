#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME): $(REQUIRES))

# aapt crunch -S $(SRCDIR)/res -C $(OUT)/$(NAME)/res
#$(OUT)/$(NAME): $(OUT)/$(NAME)/classes.jar
$(OUT)/$(NAME): $(OUT)/$(NAME)/classes.deleted

$(OUT)/$(NAME)/classes.deleted: classes := $(OUT)/$(NAME)/classes
$(OUT)/$(NAME)/classes.deleted: $(OUT)/$(NAME)/classes
#	@find $(classes) -type f \( -name 'R.class' -or -name 'R$$*.class' \) -delete
	@find $(classes) -type f \( -name 'R.class' -or -name 'R$$*.class' \) -print > $@
	@for f in $$(cat $@) ; do rm -f $$f; done
	@touch $@

$(OUT)/$(NAME)/classes.jar: classes := $(OUT)/$(NAME)/classes
$(OUT)/$(NAME)/classes.jar: $(OUT)/$(NAME)/classes.deleted
	@mkdir -p $(@D)
	jar cf $@ -C $(classes) .
#	jar cvfm $@ manifest -C $(classes) .

$(OUT)/$(NAME)/res: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/res: command = $(aapt) crunch -S $< -C $@
$(OUT)/$(NAME)/res: $(SRCDIR)/res
	@mkdir -p $@
	$(command)

ifneq ($(wildcard $(OUT)/$(NAME)/sources/R.java.d),)
  -include $(OUT)/$(NAME)/sources/R.java.d
endif
$(OUT)/$(NAME)/sources/R.java.d: $(OUT)/$(NAME)/sources
$(OUT)/$(NAME)/sources: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/sources: package := $(R_PACKAGE)
$(OUT)/$(NAME)/sources: manifest := $(wildcard $(SRCDIR)/AndroidManifest.xml)
$(OUT)/$(NAME)/sources: assets := $(wildcard $(SRCDIR)/assets) $(ASSETS)
$(OUT)/$(NAME)/sources: reses := $(wildcard $(SRCDIR)/res) $(RES)
$(OUT)/$(NAME)/sources: libs := $(LIBS.java) $(ANDROID_PLATFORM_LIB)
$(OUT)/$(NAME)/sources: out := $(OUT)/$(NAME)
$(OUT)/$(NAME)/sources: command = \
	$(aapt) package -f -m -x \
	-J "$(out)/sources" \
	-P "$(out)/public.xml" \
	-G "$(out)/res.proguard" \
	$(addprefix --custom-package ,$(package)) \
	$(addprefix -M ,$(manifest)) \
	$(foreach 1,$(libs),-I "$1") \
	$(foreach 1,$(reses),-S "$1") \
	$(foreach 1,$(assets),-A "$1") \
	--output-text-symbols "$(@D)" \
	--generate-dependencies \
	--non-constant-id \
	--auto-add-overlay
$(OUT)/$(NAME)/sources: $(OUT)/$(NAME)/res
$(OUT)/$(NAME)/sources: $(SRCDIR)/AndroidManifest.xml
	@mkdir -p $@
	$(command)
	@touch $@	

$(OUT)/$(NAME)/.sources: $(OUT)/$(NAME)/sources
	@echo "Gen source list for $(package).."
	@mkdir -p $(@D) && echo -n > $@
	@(for f in $(sources) ; do echo $$f ; done) >> $@
	@find "$(@D)/sources" -type f -name '*.java' >> $@
#	@find "$(@D)/sources" -type f -name '*.java' -and -not -name 'R.java' >> $@
