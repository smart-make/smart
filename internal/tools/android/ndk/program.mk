#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~program := $(addprefix $~,$(PROGRAM:$~%=%))

$(call smart~unique,smart~LDFLAGS)
$(call smart~unique,smart~LDLIBS)

$(eval $(smart~program): $(smart~OBJS) $(smart~LIBS) | $(dir $(smart~program)) ; \
	$(TARGET_CXX) --sysroot=$(SYSROOT) -Wl,--gc-sections -Wl,-z,nocopyreloc \
	-o $$@ $(smart~OBJS) $(smart~LIBS) $(smart~LDFLAGS) $(smart~LDLIBS))
$(eval $(OUT)/$(NAME).native: NATIVE_LIST += $(smart~program))
