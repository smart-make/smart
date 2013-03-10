#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~library := $(addprefix $~,$(LIBRARY:$~%=%))
smart~library.a := $(filter %.a,$(smart~library))
smart~library.so := $(filter %.so,$(smart~library))

ifneq ($(filter-out $(smart~library),$(smart~library.a) $(smart~library.so)),)
  $(error unregonized libraries "$(filter-out $(smart~library),$(smart~library.a) $(smart~library.so))")
endif

##
## Static library
## 
ifdef smart~library.a
$(call smart~unique,smart~ARFLAGS)
$(eval $(smart~library.a): $(smart~OBJS) | $(dir $(smart~library.a)); \
	$(TARGET_AR) $(smart~ARFLAGS) $$@ $(smart~OBJS))
endif #smart~library.a

##
## Shared library
## 
ifdef smart~library.so
$(call smart~unique,smart~LDFLAGS)
$(call smart~unique,smart~LDLIBS)
$(eval $(smart~library.so): $(smart~OBJS) $(smart~LIBS) | $(dir $(smart~library.so)) ; \
	$(TARGET_CXX) -shared -Wl,-soname,$$(@F) --sysroot=$(SYSROOT) \
	-o $$@ $(smart~OBJS) $(smart~LIBS) $(smart~LDFLAGS) $(smart~LDLIBS))
$(eval $(OUT)/$(NAME).native: NATIVE_LIST += $(smart~library.so))
endif #smart~library.so
