$(smart.internal)

os_Linux := linux
os = $(os_$(shell uname -s))
arch_x86_64 := amd64
arch = $(arch_$(shell uname -m))

smart~srcdir = $(GOPATH)/src/$(smart~pkg)
smart~outpkg = $(GOPATH)/pkg/$(os)_$(arch)/$(notdir $(smart~pkg)).a
smart~packages :=

define smart~build~package
$(eval \
  smart~packages += $(smart~outpkg)
  module-$(SCRIPT): $(smart~outpkg)
  $(smart~outpkg) : $(wildcard $(smart~srcdir)/*.go)
	@bash $(smart.tooldir)/go.bash pkg $(smart~srcdir) $$(@F)
 )
endef #smart~build~package

$(foreach smart~pkg,$(PACKAGES),$(smart~build~package))
