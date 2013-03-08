#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~sufixes~c := .c
smart~sufixes~c++ := .C .cc .cpp

smart~sources := $(patsubst $(ROOT)/%,%,$(SOURCES:%=$(SRCDIR)/%))
OBJECTS :=

#$(warning $(smart~sources))

CFLAGS := $(TARGET_CFLAGS) $(CFLAGS)
CXXFLAGS := $(TARGET_CFLAGS) $(CXXFLAGS)
INCLUDES := $(TARGET_C_INCLUDES) $(INCLUDES)

$(call smart~unique,CFLAGS)
$(call smart~unique,CXXFLAGS)
$(call smart~unique,DEFINES)
$(call smart~unique,INCLUDES)

INCLUDES := $(patsubst %,-I%,$(INCLUDES:-I%=%))

COMPILE.c++ = $(TARGET_CXX) -o $$@ $(strip $(CXXFLAGS) $(DEFINES) $(INCLUDES) -c) $$<
COMPILE.c   = $(TARGET_CC) -o $$@ $(strip $(CFLAGS) $(DEFINES) $(INCLUDES) -c) $$<

define smart~compile~rules
$(eval SOURCES$2 := $(filter %$2, $(smart~sources)))\
$(eval OBJECTS += $(SOURCES$2:%$2=$~%.o))\
$(eval \
  ifdef SOURCES$2
  $(SOURCES$2:%$2=$~%.o) : $~%.o : %$2
	@mkdir -p $$(@D)
	$(COMPILE.$1)
  endif
 )
endef #smart~compile~rules

ifdef  smart~sources
  ~ := $(OUT)/objs/$(TARGET_ABI)/
  $(foreach 1,c c++,\
    $(foreach 2,$(smart~sufixes~$1),$(smart~compile~rules)))
endif #smart~sources

#$(warning $(NAME): $(OBJECTS))
