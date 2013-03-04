#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

s := $(OUT)/libs/$(TARGET_ARCH_ABI)/
LIBRARY := $(addprefix $s,$(LIBRARY:$s%=%))
LIBRARY.a := $(filter %.a,$(LIBRARY))
LIBRARY.so := $(filter %.so,$(LIBRARY))

ifneq ($(filter-out $(LIBRARY),$(LIBRARY.a) $(LIBRARY.so)),)
  $(error unregonized libraries "$(filter-out $(LIBRARY),$(LIBRARY.a) $(LIBRARY.so))")
endif

$(call smart~unique,ARFLAGS)
$(call smart~unique,LDFLAGS)

ifdef LIBRARY.a
$(eval $(LIBRARY.a): $(OBJECTS) ; \
	$(AR) $(ARFLAGS) $$@ $$^)
endif #LIBRARY.a

ifdef LIBRARY.so
LDFLAGS := $(filter-out -shared,$(LDFLAGS))
$(eval $(LIBRARY.so): $(OBJECTS) ; \
	$(CXX) -shared $(LDFLAGS) -o $$@ $$^ $(LDLIBS))
endif #LIBRARY.so

$(warning $(LIBRARY.a), $(LIBRARY.so))
