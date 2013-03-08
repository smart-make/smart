#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~program := $(addprefix $~,$(PROGRAM:$~%=%))

$(call smart~unique,LDFLAGS)

LDFLAGS := $(TARGET_LDFLAGS) $(filter-out -shared,$(LDFLAGS))

$(eval $(smart~program): $(OBJECTS) $(dir $(smart~program)) ; \
	$(TARGET_CXX) $(LDFLAGS) --sysroot=$(SYSROOT) \
	-Wl,--gc-sections -Wl,-z,nocopyreloc \
	-o $$@ $(OBJECTS) $(LDLIBS))
$(eval $(OUT)/$(NAME).native: NATIVE_LIST += $(smart~program))
