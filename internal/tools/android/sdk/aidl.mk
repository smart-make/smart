#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#

define smart~rule
  SOURCES.java_from_aidl := @$(OUT)/$(NAME)/.sources_aidl
  $(OUT)/$(NAME)/.classes : $(OUT)/$(NAME)/.sources_aidl
  $(OUT)/$(NAME)/.sources_aidl : $(SOURCES.aidl)
	@mkdir -p "$$(@D)"
	@for f in $$^ ; do echo "aidl $$$$f"; \
	if grep "^parcelable\s.*;" $$$$f > /dev/null ; then true; else \
	$(ANDROID.aidl) -I"$(SRCDIR)/src" -p"$(ANDROID_PREPROCESS_IMPORT)" \
	-o"$(OUT)/$(NAME)/sources" -b $$$$f ; fi ; done
	@find "$(OUT)/$(NAME)/sources" -type f -name '*.java' > $$@
endef #smart~rule

$(eval $(smart~rule))

smart~rule =
