$(smart.internal)

SOURCES := $(SOURCES:%=$(SRCDIR)/%)
SOURCES.cc := $(filter %.cc, $(SOURCES))
SOURCES.cpp := $(filter %.cpp, $(SOURCES))
SOURCES.C := $(filter %.C, $(SOURCES))
SOURCES.c := $(filter %.c, $(SOURCES))

OBJECTS := \
  $(SOURCES.cc:%.cc=%.o)\
  $(SOURCES.cpp:%.cpp=%.o)\
  $(SOURCES.C:%.C=%.o)\
  $(SOURCES.c:%.c=%.o)\

CFLAGS += $(sort $(filter -I%,$(INCLUDES)))
CFLAGS += $(patsubst %,-I%,$(sort $(filter-out -I%,$(INCLUDES))))

CXXFLAGS += $(sort $(filter -I%,$(INCLUDES)))
CXXFLAGS += $(patsubst %,-I%,$(sort $(filter-out -I%,$(INCLUDES))))

COMPILE.c++ = $(CXX) -o $$@ $(CXXFLAGS) $(DEFINES) -c $$<
COMPILE.go = $(GCCGO) -o $$@ $(GOFLAGS) $(DEFINES) -c $$<
COMPILE.c = $(CC) -o $$@ $(CFLAGS) $(DEFINES) -c $$<

$(eval $(SOURCES.cpp:%.cpp=%.o):%.o:%.cpp ; $(COMPILE.c++))
$(eval $(SOURCES.go:%.go=%.o):%.o:%.go ; $(COMPILE.go))
$(eval $(SOURCES.c:%.c=%.o):%.o:%.c ; $(COMPILE.c))
