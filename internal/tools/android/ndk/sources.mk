#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

SOURCES := $(patsubst $(ROOT)/%,%,$(SOURCES:%=$(SRCDIR)/%))
SOURCES.cc := $(filter %.cc, $(SOURCES))
SOURCES.cpp := $(filter %.cpp, $(SOURCES))
SOURCES.C := $(filter %.C, $(SOURCES))
SOURCES.c := $(filter %.c, $(SOURCES))
SOURCES.s := $(filter %.s, $(SOURCES))
SOURCES.S := $(filter %.S, $(SOURCES))

OBJECTS := \
  $(SOURCES.cc:%.cc=%.o)\
  $(SOURCES.cpp:%.cpp=%.o)\
  $(SOURCES.C:%.C=%.o)\
  $(SOURCES.c:%.c=%.o)\
  $(SOURCES.s:%.s=%.o)\
  $(SOURCES.S:%.S=%.o)\

s := $(OUT)/objs/$(TARGET_ABI)/
OBJECTS := $(OBJECTS:%=$s%)

$(call smart~unique,DEFINES)
$(call smart~unique,INCLUDES)
$(call smart~unique,CFLAGS)
$(call smart~unique,CXXFLAGS)

INCLUDES := $(patsubst %,-I%,$(INCLUDES:-I%=%))

COMPILE.c++ = $(TARGET_CXX) -o $$@ $(strip $(CXXFLAGS) $(DEFINES) $(INCLUDES) -c) $$<
COMPILE.c   = $(TARGET_CC) -o $$@ $(strip $(CFLAGS) $(DEFINES) $(INCLUDES) -c) $$<
COMPILE.s   = $(TARGET_AS) -o $$@ $(strip $(ASFLAGS) $(INCLUDES)) $$<

$(eval $(SOURCES.cc:%.cc=$s%.o):	$s%.o:%.cc	; $(COMPILE.c++))
$(eval $(SOURCES.cpp:%.cpp=$s%.o):	$s%.o:%.cpp	; $(COMPILE.c++))
$(eval $(SOURCES.c:%.c=$s%.o):		$s%.o:%.c	; $(COMPILE.c))
$(eval $(SOURCES.s:%.s=$s%.o):		$s%.o:%.s	; $(COMPILE.c))
$(eval $(SOURCES.S:%.S=$s%.o):		$s%.o:%.S	; $(COMPILE.c))
