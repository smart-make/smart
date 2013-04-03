#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#

define smart~rule
  SOURCES.java_from_aidl := `cat $(OUT)/$(NAME)/sources/.list`
  $(OUT)/$(NAME)/classes/.list : $(OUT)/$(NAME)/sources/.list
  $(OUT)/$(NAME)/sources/.list : $(SOURCES.aidl)
	@mkdir -p "$$(@D)"
	@for f in $$^ ; do echo "compile $$$$f"; \
	$(ANDROID.aidl) -I"$(SRCDIR)/src" -I"$(ANDROID_PLATFORM_LIB)" \
	$(addprefix -I,$(LIBS.java)) -p"$(ANDROID_PREPROCESS_IMPORT)" \
	-o"$(OUT)/$(NAME)/sources" -b $$$$f ; done
	@find "$$(@D)" -type f -name '*.java' > $$@
endef #smart~rule

$(eval $(smart~rule))

smart~rule =
