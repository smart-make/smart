#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

#$(warning info: save $(NAME), $(SRCDIR), $(SM.MK))

define smart~save.simple
$(eval \
  ifdef $(smart~name)
    smart.context.$(smart~name)-$(SM.MK) := $($(smart~name))
  endif
 )
endef #smart~save.simple

define smart~save.recursive
$(eval \
  ifdef $(smart~name)
    smart.context.$(smart~name)-$(SM.MK) = $(value $(smart~name))
  endif
 )
endef #smart~save.recursive

#define smart~save.undefined
#endef #smart~save.undefined

define smart~save
$(smart~save.$(flavor $(smart~name)))
endef #smart~save

$(foreach smart~name,$(smart.context.names),$(smart~save))
$(foreach smart~name,$(smart.context.names:%=EXPORT.%),$(smart~save))

ifdef smart.scripts.$(NAME)
  smart.scripts.$(NAME) += $(SM.MK)
else
  smart.scripts.$(NAME) := $(SM.MK)
endif

smart.names-$(SM.MK) := $(NAME)
smart.list += $(SM.MK)

smart~save.simple :=
smart~save.recursive :=
smart~save :=
smart~name :=

ifndef SRCDIR
  smart~error := SRCDIR is undefined
  $(error $(smart~error))
endif #!SRCDIR

ifdef SUBDIRS
  include $(smart.root)/internal/subdirs.mk
endif #SUBDIRS
