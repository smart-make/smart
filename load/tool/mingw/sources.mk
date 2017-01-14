$(smart.internal)

SOURCES := $(SOURCES:%=$(SRCDIR)/%)
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

$(call smart~unique,DEFINES)
$(call smart~unique,INCLUDES)
$(call smart~unique,CFLAGS)
$(call smart~unique,CXXFLAGS)

INCLUDES := $(patsubst %,-I%,$(INCLUDES:-I%=%))
INCLUDES := $(patsubst %,-I%,$(INCLUDES:-I%=%))

COMPILE.c++ = $(TOOLPREFIX)g++ -o $$@ $(strip $(CXXFLAGS) $(DEFINES) $(INCLUDES) -c) $$<
COMPILE.go = $(TOOLPREFIX)gccgo -o $$@ $(strip $(GOFLAGS) $(DEFINES) $(INCLUDES) -c) $$<
COMPILE.c = $(TOOLPREFIX)gcc -o $$@ $(strip $(CFLAGS) $(DEFINES) $(INCLUDES) -c) $$<

$(eval $(SOURCES.cc:%.cc=%.o):%.o:%.cc	  ; $(COMPILE.c++))
$(eval $(SOURCES.cpp:%.cpp=%.o):%.o:%.cpp ; $(COMPILE.c++))
$(eval $(SOURCES.go:%.go=%.o):%.o:%.go	  ; $(COMPILE.go))
$(eval $(SOURCES.c:%.c=%.o):%.o:%.c	  ; $(COMPILE.c))
$(eval $(SOURCES.s:%.s=%.o):%.o:%.s	  ; $(COMPILE.c))
$(eval $(SOURCES.S:%.S=%.o):%.o:%.S	  ; $(COMPILE.c))
