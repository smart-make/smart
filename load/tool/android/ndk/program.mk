#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~program := $(addprefix $(TARGET_OUT)/,$(PROGRAM:$(TARGET_OUT)/%=%))

#$(warning $(NAME): LDFLAGS: $(smart~LDFLAGS))
#$(warning $(NAME): LDLIBS: $(smart~LDLIBS))
#$(warning $(NAME): LIBS: $(smart~LIBS))

#smart~LIBS := $(filter %.so %.a,$(smart~LIBS))

$(call smart~unique,smart~LDFLAGS)
$(call smart~unique,smart~LDLIBS)
$(call smart~make~target~dir,$(smart~program))
$(eval $(smart~program): $(smart~OBJS) $(smart~LIBS) $(smart~DEPS) | $(dir $(smart~program)) ; \
	$(TARGET_CXX) --sysroot=$(SYSROOT) -Wl,--gc-sections -Wl,-z,nocopyreloc \
	-o $$@ $(smart~OBJS) $(smart~LIBS) $(smart~LDFLAGS) $(smart~LDLIBS))
$(OUT)/$(NAME).native: $(smart~program)
clean-$(SCRIPT): smart~clean~files += $(smart~program)
