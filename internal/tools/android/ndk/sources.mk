#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~sufixes~c := .c
smart~sufixes~c++ := .C .cc .cpp

smart~sources := $(patsubst $(ROOT)/%,%,$(SOURCES:%=$(SRCDIR)/%))

$(call smart~unique,smart~CFLAGS)
$(call smart~unique,smart~CXXFLAGS)
$(call smart~unique,smart~CPPFLAGS)
$(call smart~unique,smart~DEFINES)
$(call smart~unique,smart~INCLUDES)

smart~INCLUDES := $(patsubst %,-I%,$(smart~INCLUDES:-I%=%))

COMPILE.c   = $(TARGET_CC) -o $$@ $(smart~CFLAGS) $(smart~DEFINES) $(smart~INCLUDES) -c $$<
COMPILE.c++ = $(TARGET_CXX) -o $$@ $(smart~CFLAGS) $(smart~CXXFLAGS) $(smart~CPPFLAGS) $(smart~DEFINES) $(smart~INCLUDES) -c $$<

define smart~compile~rules
$(eval smart~s := $(filter %$2, $(smart~sources)))\
$(eval smart~o := $(smart~s:%$2=$(TARGET_OBJS)/%.o))\
$(if $(and $(smart~s),$(smart~o)),$(eval \
  smart~OBJS += $(smart~o)
  $(smart~o) : $(TARGET_OBJS)/%.o : %$2 | $(dir $(sort $(smart~o)))
	$(COMPILE.$1)
 )$(foreach o,$(smart~o),$(call smart~make~target~dir,$o)))
endef #smart~compile~rules

ifdef  smart~sources
  $(foreach 1,c c++,$(foreach 2,$(smart~sufixes~$1),$(smart~compile~rules)))
endif #smart~sources

smart~OBJS := $(strip $(smart~OBJS))
