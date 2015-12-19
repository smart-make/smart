$(smart.internal)
$(eval settle-$(SCRIPT): module-$(SCRIPT); @echo TODO: settle "$(OUT)/$(SRCDIR:$(or $(ROOT),$(smart.settle_root))/%=%)/$(NAME)")
