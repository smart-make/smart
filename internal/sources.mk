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

COMPILE.c++ = $(CXX) $(CXXFLAGS) -c -o $$@ $$<
COMPILE.go = $(GCCGO) $(GOFLAGS) -c -o $$@ $$<
COMPILE.c = $(CC) $(CFLAGS) -c -o $$@ $$<

$(eval $(SOURCES.cpp:%.cpp=%.o):%.o:%.cpp ; $(COMPILE.c++))
$(eval $(SOURCES.go:%.go=%.o):%.o:%.go ; $(COMPILE.go))
$(eval $(SOURCES.c:%.c=%.o):%.o:%.c ; $(COMPILE.c))
