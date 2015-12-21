$(smart.internal)

SOURCES := $(SOURCES:%=$(SRCDIR)/%)
SOURCES.cc := $(filter %.cc, $(SOURCES))
SOURCES.cpp := $(filter %.cpp, $(SOURCES))
SOURCES.C := $(filter %.C, $(SOURCES))
SOURCES.c := $(filter %.c, $(SOURCES))
SOURCES.s := $(filter %.s, $(SOURCES))
SOURCES.S := $(filter %.S, $(SOURCES))
SOURCES.go := $(filter %.go, $(SOURCES))

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

define COMPILE.c++
  $(CXX) -o $$@ $(CXXFLAGS) $(DEFINES) $(INCLUDES) -c $$<
endef

define COMPILE.c++.d
  $(CXX) -MMD -MP -MF $$@ -MT $$(@:%.d=%.o) $(CXXFLAGS) $(DEFINES) $(INCLUDES) -c $$<
endef

define COMPILE.go
  $(GCCGO) -o $$@ $(GOFLAGS) $(DEFINES) $(INCLUDES) -c $$<
endef

define COMPILE.go.d
  $(GCCGO) -MMD -MP -MF $$@ -MT $$(@:%.d=%.o) $(GOFLAGS) $(DEFINES) $(INCLUDES) -c $$<
endef

define COMPILE.c
  $(CC) -o $$@ $(CFLAGS) $(DEFINES) $(INCLUDES) -c $$<
endef

define COMPILE.c.d
  $(CC) -MMD -MP -MF $$@ -MT $$(@:%.d=%.o) $(CFLAGS) $(DEFINES) $(INCLUDES) -c $$<
endef

define COMPILE.s
  $(AS) -o $$@ $(ASFLAGS) $(INCLUDES) $$<
endef

define COMPILE.s.d
  $(AS) -MMD -MP -MF $$@ -MT $$(@:%.d=%.o) $(ASFLAGS) $(INCLUDES) $$<
endef

$(eval $(SOURCES.cc:%.cc=%.o):%.o:%.cc	  ; $(COMPILE.c++))
$(eval $(SOURCES.cpp:%.cpp=%.o):%.o:%.cpp ; $(COMPILE.c++))
$(eval $(SOURCES.go:%.go=%.o):%.o:%.go	  ; $(COMPILE.go))
$(eval $(SOURCES.c:%.c=%.o):%.o:%.c	  ; $(COMPILE.c))
$(eval $(SOURCES.s:%.s=%.o):%.o:%.s	  ; $(COMPILE.s))
$(eval $(SOURCES.S:%.S=%.o):%.o:%.S	  ; $(COMPILE.s))

$(eval $(SOURCES.cc:%.cc=%.d):%.d:%.cc	  ; $(COMPILE.c++.d))
$(eval $(SOURCES.cpp:%.cpp=%.d):%.d:%.cpp ; $(COMPILE.c++.d))
$(eval $(SOURCES.go:%.go=%.d):%.d:%.go	  ; $(COMPILE.go.d))
$(eval $(SOURCES.c:%.c=%.d):%.d:%.c	  ; $(COMPILE.c.d))
$(eval $(SOURCES.s:%.s=%.d):%.d:%.s	  ; $(COMPILE.s.d))
$(eval $(SOURCES.S:%.S=%.d):%.d:%.S	  ; $(COMPILE.s.d))

$(foreach d,$(OBJECTS:%.o=%.d),$(eval -include $d))
