#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

~ := $(OUT)/libs/$(TARGET_ARCH_ABI)/
smart~library := $(addprefix $~,$(LIBRARY:$~%=%))
smart~library.a := $(filter %.a,$(smart~library))
smart~library.so := $(filter %.so,$(smart~library))

ifneq ($(filter-out $(smart~library),$(smart~library.a) $(smart~library.so)),)
  $(error unregonized libraries "$(filter-out $(smart~library),$(smart~library.a) $(smart~library.so))")
endif

$(call smart~unique,ARFLAGS)
$(call smart~unique,LDFLAGS)

ifdef smart~library.a
$(dir $(smart~library.a)): ; mkdir -p $@
$(eval $(smart~library.a): $(OBJECTS) ; \
	$(TARGET_AR) $(ARFLAGS) $$@ $(OBJECTS))
endif #smart~library.a

ifdef smart~library.so
LDFLAGS := $(TARGET_LDFLAGS) $(filter-out -shared,$(LDFLAGS))

$(dir $(smart~library.so)): ; mkdir -p $@
$(eval $(smart~library.so): $(OBJECTS) $(dir $(smart~library.so)) ; \
	$(TARGET_CXX) -shared $(LDFLAGS) \
	-Wl,-soname,$$(@F) --sysroot=$(SYSROOT) \
	-o $$@ $(OBJECTS) $(LDLIBS))
endif #smart~library.so
