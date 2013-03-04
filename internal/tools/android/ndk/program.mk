#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

s := $(OUT)/libs/$(TARGET_ARCH_ABI)/
PROGRAM := $(addprefix $s,$(PROGRAM:$s%=%))

$(call smart~unique,LDFLAGS)

$(eval $(PROGRAM): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -o $$@ $$^ $(LDLIBS))

#$(warning $(PROGRAM))
