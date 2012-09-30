MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

ifndef SRCDIR
  smart~error := SRCDIR is undefined
  $(error $(smart~error))
endif

ifdef SUBDIRS
$(foreach @loadee,$(SUBDIRS),$(smart.load))
endif #SUBDIRS

ifdef SOURCES

ifeq ($(shell uname),Linux)

else # uname == Linux
LOADLIBS += \
  -lkernel32\
  -luser32\
  -lgdi32\
  -lcomdlg32\
  -lwinspool\
  -lwinmm\
  -lshell32\
  -lcomctl32\
  -lole32\
  -loleaut32\
  -luuid\
  -lrpcrt4\
  -ladvapi32\
  -lwsock32\
  -lodbc32\
  -lws2_32\
  -lnetapi32\
  -lmpr\

endif # uname != Linux

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

ifdef PROGRAMS
  PROGRAMS := $(PROGRAMS:%=$(SRCDIR)/%)
  modules: $(PROGRAMS)
  $(eval $(PROGRAMS): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -o $$@ $$^ $(LOADLIBS))
endif #PROGRAMS

ifdef LIBRARIES
  LIBRARIES := $(LIBRARIES:%=$(SRCDIR)/%)
  LIBRARIES.a := $(filter %.a,$(LIBRARIES))
  LIBRARIES.so := $(filter %.so,$(LIBRARIES))
  modules: $(LIBRARIES.a) $(LIBRARIES.so)
  $(eval $(LIBRARIES.a): $(OBJECTS) ; \
	$(AR) $(ARFLAGS) $$@ $$^ $(LIBADD))
  $(eval $(LIBRARIES.so): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -shared -o $$@ $$^ $(LOADLIBS))
endif #LIBRARIES

COMPILE.c++ = $(CXX) $(CXXFLAGS) -c -o $$@ $$<
COMPILE.go = $(GCCGO) $(GOFLAGS) -c -o $$@ $$<
COMPILE.c = $(CC) $(CFLAGS) -c -o $$@ $$<

$(eval $(SOURCES.cpp:%.cpp=%.o):%.o:%.cpp ; $(COMPILE.c++))
$(eval $(SOURCES.go:%.go=%.o):%.o:%.go ; $(COMPILE.go))
$(eval $(SOURCES.c:%.c=%.o):%.o:%.c ; $(COMPILE.c))

clean: clean-$(SM.MK)
$(eval clean-$(SM.MK): ; \
  rm -vf $(strip $(LIBRARIES) $(PROGRAMS) $(OBJECTS)))

endif #SOURCES
