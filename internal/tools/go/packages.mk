$(smart.internal)

smart~srcdir = $(GOPATH)/src/$(smart~pkg)
smart~outpkg = $(GOPATH)/pkg/$(notdir $(smart~pkg))

define smart~build~package
$(eval \
  module-$(SCRIPT): $(smart~outpkg)
  $(smart~outpkg) : $(wildcard $(smart~srcdir)/*.go)
	@bash $(smart.tooldir)/go.bash pkg $(smart~srcdir) $$(@F)
 )
endef #smart~build~package

$(foreach smart~pkg,$(PACKAGES),$(smart~build~package))
