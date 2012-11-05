define smart~rule
  $(OUT)/$(NAME)/classes/.list : $(SOURCES.java) | $(LIBS.local)
	@mkdir -p $$(@D)
	javac -d $$(@D) -cp "$(CLASSPATH)" \
	`cat $(OUT)/$(NAME)/res/.sources` $$^
	@cd $$(@D) && find . -type f -name '*.class' > $$(@F)
endef #smart~rule

$(eval $(smart~rule))

define smart~rule
  $(OUT)/$(NAME)/classes.dex: $(OUT)/$(NAME)/classes/.list
	cd $(OUT)/$(NAME)/classes && $(ANDROID.dx) \
	$(if $(findstring windows,$(sm.os.name)),,-JXms16M -JXmx1536M)\
	--dex --output ../$$(@F) \
	$(LIBS) `cat $$(<F) | sed 's|^\./||'`
endef #smart~rule

$(eval $(smart~rule))

smart~rule =
