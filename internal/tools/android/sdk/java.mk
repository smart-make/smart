#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

define smart~rule
  $(OUT)/$(NAME)/.classpath : $(LIBS.java)
	@mkdir -p $$(@D) && echo '-cp "$(CLASSPATH)"' > $$@
  $(OUT)/$(NAME)/.sources : $(SOURCES.java)
	@mkdir -p $$(@D) && echo -n > $$@
	@for f in $$^ ; do echo $$$$f >> $$@ ; done
  $(OUT)/$(NAME)/.classes : \
    $(OUT)/$(NAME)/.sources $(OUT)/$(NAME)/res/.sources \
    $(OUT)/$(NAME)/.classpath | $(LIBS.java)
	@mkdir -p $(OUT)/$(NAME)/classes
	@rm -vf $(OUT)/$(NAME)/classes.dex
	javac -d $(OUT)/$(NAME)/classes "@$(OUT)/$(NAME)/.classpath" \
	"@$(OUT)/$(NAME)/res/.sources" "@$(OUT)/$(NAME)/.sources" \
	$(SOURCES.java_from_aidl)
	@cd $(OUT)/$(NAME)/classes && find . -type f -name '*.class' > ../$$(@F)
endef #smart~rule

$(eval $(smart~rule))

ifdef PROGUARD
  include $(smart.tooldir)/proguard.mk
  smart~dex~list := $(OUT)/$(NAME)/classes-obfuscated.jar
  smart~dex~dest := $(OUT)/$(NAME)
  smart~dex~input := classes-obfuscated.jar
  smart~dex~output := classes.dex
else
  smart~dex~list := $(OUT)/$(NAME)/.classes
  smart~dex~dest := $(OUT)/$(NAME)/classes
  smart~dex~input := .
  smart~dex~output := ../classes.dex
endif #PROGUARD

define smart~rule
  CLASSES.DEX := $(OUT)/$(NAME)/classes.dex
  $(OUT)/$(NAME)/classes.dex: $(smart~dex~list)
	@rm -vf $(APK) \
		$(OUT)/$(NAME)/_.pack \
		$(OUT)/$(NAME)/_.unsigned \
		$(OUT)/$(NAME)/_.signed
	cd $(smart~dex~dest) && $(ANDROID.dx) \
	$(if $(findstring windows,$(sm.os.name)),,-JXms16M -JXmx1536M)\
	--dex --output $(smart~dex~output) $(LIBS.java) $(smart~dex~input)
endef #smart~rule

ifneq ($(SOURCES.java),)
  $(eval $(smart~rule))
else
  CLASSES.DEX :=
endif

smart~rule =
smart~dex~list :=
smart~dex~input :=
