#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME): $(REQUIRES))

# aapt crunch -S $(SRCDIR)/res -C $(OUT)/$(NAME)/$V/res
#$(OUT)/$(NAME)/$V: $(OUT)/$(NAME)/$V/classes.jar
#$(OUT)/$(NAME)/$V: $(OUT)/$(NAME)/$V/classes.deleted

$(OUT)/$(NAME)/$V/classes.deleted: classes := $(OUT)/$(NAME)/$V/classes
$(OUT)/$(NAME)/$V/classes.deleted: $(OUT)/$(NAME)/$V/.classes
#	@find $(classes) -type f \( -name 'R.class' -or -name 'R$$*.class' \) -delete
	@find $(classes) -type f \( -name 'R.class' -or -name 'R$$*.class' \) -print > $@
	@for f in $$(cat $@) ; do rm -f $$f; done

$(OUT)/$(NAME)/$V/classes.jar: classes := $(OUT)/$(NAME)/$V/classes
$(OUT)/$(NAME)/$V/classes.jar: $(OUT)/$(NAME)/$V/classes.deleted
	@mkdir -p $(@D)
	jar cf $@ -C $(classes) .
#	jar cvfm $@ manifest -C $(classes) .

$(smart~r.java): command = \
	$(aapt) package -f -m -x \
	-J "$(out)/sources" \
	-P "$(out)/public.xml" \
	-G "$(out)/res.proguard" \
	$(addprefix --custom-package ,$(r-package)) \
	$(addprefix -M ,$(manifest)) \
	$(foreach 1,$(libs),-I "$1") \
	$(foreach 1,$(reses),-S "$1") \
	$(foreach 1,$(assets),-A "$1") \
	--output-text-symbols "$(@D)" \
	--generate-dependencies \
	--non-constant-id \
	--auto-add-overlay
