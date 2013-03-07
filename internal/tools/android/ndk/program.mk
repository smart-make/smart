#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

~ := $(OUT)/libs/$(TARGET_ARCH_ABI)/
smart~program := $(addprefix $~,$(PROGRAM:$~%=%))

$(call smart~unique,LDFLAGS)

LDFLAGS := $(TARGET_LDFLAGS) $(filter-out -shared,$(LDFLAGS))

#$(dir $(smart~program)): ; mkdir -p $@
$(eval $(smart~program): $(OBJECTS) $(dir $(smart~program)) ; \
	$(TARGET_CXX) $(LDFLAGS) --sysroot=$(SYSROOT) \
	-Wl,--gc-sections -Wl,-z,nocopyreloc \
	-o $$@ $(OBJECTS) $(LDLIBS))
