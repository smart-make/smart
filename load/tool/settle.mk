$(smart.internal)
$(eval \
  settle-$(SCRIPT): module-$(SCRIPT) ; \
	@echo "smart: TODO: settle $(OUT)/$(SRCDIR:$(or $(ROOT),$(smart.settle_root))/%=%)/$(NAME)" \
 )
