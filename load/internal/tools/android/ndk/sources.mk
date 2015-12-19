#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~sufixes~c := .c
smart~sufixes~asm := .s .S
smart~sufixes~c++ := .C .cc .cpp

smart~sources := $(patsubst $(ROOT)/%,%,$(SOURCES:%=$(SRCDIR)/%))

$(call smart~unique,smart~CFLAGS)
$(call smart~unique,smart~CXXFLAGS)
$(call smart~unique,smart~CPPFLAGS)
$(call smart~unique,smart~DEFINES)
$(call smart~unique,smart~INCLUDES)

smart~INCLUDES := $(patsubst %,-I%,$(smart~INCLUDES:-I%=%))

define smart~compile.c
$(TARGET_CC) \
  -MMD -MP -MF $$(@:%.o=%.d) -MT $$@ \
  -o $$@ $(smart~CFLAGS) $(smart~DEFINES) $(smart~INCLUDES) \
  -c $$<
endef #smart~compile.c

smart~compile.asm = $(smart~compile.c)

define smart~compile.c++
$(TARGET_CXX) \
  -MMD -MP -MF $$(@:%.o=%.d) -MT $$@ \
  -o $$@ $(smart~CFLAGS) $(smart~CXXFLAGS) $(smart~CPPFLAGS) \
  $(smart~DEFINES) $(smart~INCLUDES) -c $$<
endef #smart~compile.c++

define smart~compile~rules
$(eval smart~s := $(filter %$2, $(smart~sources)))\
$(eval smart~o := $(smart~s:%$2=$(TARGET_OBJS)/%.o))\
$(eval smart~d := $(smart~o:%.o=%.d))\
$(if $(and $(smart~s),$(smart~o)),$(eval \
  smart~OBJS += $(smart~o)
  $(smart~o) : $(TARGET_OBJS)/%.o : %$2 | $(dir $(sort $(smart~o)))
	@echo "$1: $$@"
	@$(call smart~compile.$1)
 )$(foreach o,$(smart~o),$(call smart~make~target~dir,$o))\
  $(foreach d,$(smart~d),$(if $(wildcard $d),$(eval -include $d))))
endef #smart~compile~rules

ifdef  smart~sources
  $(foreach 1,asm c c++,$(foreach 2,$(smart~sufixes~$1),$(smart~compile~rules)))
endif #smart~sources

smart~OBJS := $(strip $(smart~OBJS))

ifdef smart~OBJS
  clean-$(SCRIPT): smart~clean~files += $(smart~OBJS)
endif
