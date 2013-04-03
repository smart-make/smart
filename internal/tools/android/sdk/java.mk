#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

define smart~rule
  $(OUT)/$(NAME)/classes/.list : $(SOURCES.java) | $(LIBS.java)
	@mkdir -p $$(@D)
	javac -d $$(@D) -cp "$(CLASSPATH)" \
	`cat $(OUT)/$(NAME)/res/.sources` \
	$(SOURCES.java) $(SOURCES.java_from_aidl)
	@cd $$(@D) && find . -type f -name '*.class' > $$(@F)
endef #smart~rule

$(eval $(smart~rule))

define smart~rule
  $(OUT)/$(NAME)/classes.dex: $(OUT)/$(NAME)/classes/.list
	cd $(OUT)/$(NAME)/classes && $(ANDROID.dx) \
	$(if $(findstring windows,$(sm.os.name)),,-JXms16M -JXmx1536M)\
	--dex --output ../$$(@F) \
	$(LIBS.java) `cat $$(<F) | sed 's|^\./||'`
endef #smart~rule

$(eval $(smart~rule))

smart~rule =
