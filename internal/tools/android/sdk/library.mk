#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME): $(REQUIRES))

# aapt crunch -S $(SRCDIR)/res -C $(OUT)/$(NAME)/$V/res
#$(OUT)/$(NAME)/$V: $(OUT)/$(NAME)/$V/classes.jar
$(OUT)/$(NAME)/$V: $(OUT)/$(NAME)/$V/classes.deleted

$(OUT)/$(NAME)/$V/classes.deleted: classes := $(OUT)/$(NAME)/$V/classes
$(OUT)/$(NAME)/$V/classes.deleted: $(OUT)/$(NAME)/$V/.classes
#	@find $(classes) -type f \( -name 'R.class' -or -name 'R$$*.class' \) -delete
	@find $(classes) -type f \( -name 'R.class' -or -name 'R$$*.class' \) -print > $@
	@for f in $$(cat $@) ; do rm -f $$f; done
	@touch $@

$(OUT)/$(NAME)/$V/classes.jar: classes := $(OUT)/$(NAME)/$V/classes
$(OUT)/$(NAME)/$V/classes.jar: $(OUT)/$(NAME)/$V/classes.deleted
	@mkdir -p $(@D)
	jar cf $@ -C $(classes) .
#	jar cvfm $@ manifest -C $(classes) .

$(OUT)/$(NAME)/$V/res: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/$V/res: command = $(aapt) crunch -S $< -C $@
$(OUT)/$(NAME)/$V/res: $(SRCDIR)/res
	@mkdir -p $@
	$(command)

ifneq ($(wildcard $(OUT)/$(NAME)/$V/sources/R.java.d),)
  -include $(OUT)/$(NAME)/$V/sources/R.java.d
endif
$(OUT)/$(NAME)/$V/sources/R.java.d: $(OUT)/$(NAME)/$V/sources
$(OUT)/$(NAME)/$V/sources: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/$V/sources: package := $(R_PACKAGE)
$(OUT)/$(NAME)/$V/sources: manifest := $(wildcard $(SRCDIR)/AndroidManifest.xml)
$(OUT)/$(NAME)/$V/sources: assets := $(wildcard $(SRCDIR)/assets) $(ASSETS)
$(OUT)/$(NAME)/$V/sources: reses := $(wildcard $(SRCDIR)/res) $(RES)
$(OUT)/$(NAME)/$V/sources: libs := $(LIBS.java) $(ANDROID_PLATFORM_LIB)
$(OUT)/$(NAME)/$V/sources: out := $(OUT)/$(NAME)/$V
$(OUT)/$(NAME)/$V/sources: command = \
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
$(OUT)/$(NAME)/$V/sources: $(OUT)/$(NAME)/$V/res
$(OUT)/$(NAME)/$V/sources: $(SRCDIR)/AndroidManifest.xml
	@mkdir -p $@
	$(command)
	@touch $@	

$(OUT)/$(NAME)/$V/.sources: $(OUT)/$(NAME)/$V/sources
	@echo "Gen source list for $(package).."
	@mkdir -p $(@D) && echo -n > $@
	@(for f in $(sources) ; do echo $$f ; done) >> $@
	@find "$(@D)/sources" -type f -name '*.java' >> $@
#	@find "$(@D)/sources" -type f -name '*.java' -and -not -name 'R.java' >> $@
