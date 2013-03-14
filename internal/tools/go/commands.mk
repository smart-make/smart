$(smart.internal)

smart~srcdir = $(GOPATH)/src/$(smart~cmd)
smart~outbin = $(GOPATH)/bin/$(notdir $(smart~cmd))

define smart~build~command
$(eval \
  module-$(SCRIPT): $(smart~outbin)
  $(smart~outbin) : $(wildcard $(smart~srcdir)/*.go)
	@bash $(smart.tooldir)/go.bash cmd $(smart~srcdir) $$(@F)
 )
endef #smart~build~command

$(foreach smart~cmd,$(COMMANDS),$(smart~build~command))
