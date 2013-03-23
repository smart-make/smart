#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~program := $(addprefix $(TARGET_OUT)/,$(PROGRAM:$(TARGET_OUT)/%=%))

$(call smart~unique,smart~LDFLAGS)
$(call smart~unique,smart~LDLIBS)
$(call smart~make~target~dir,$(smart~program))
$(eval $(smart~program): $(smart~OBJS) $(smart~LIBS) | $(dir $(smart~program)) ; \
	$(TARGET_CXX) --sysroot=$(SYSROOT) -Wl,--gc-sections -Wl,-z,nocopyreloc \
	-o $$@ $(smart~OBJS) $(smart~LIBS) $(smart~LDFLAGS) $(smart~LDLIBS))
$(OUT)/$(NAME).native: $(smart~program)
clean-$(SCRIPT): smart~clean~files += $(smart~program)
