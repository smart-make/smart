MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

.SUFFIXES:

ifndef SRCDIR
  smart~error := SRCDIR is undefined
  $(error $(smart~error))
endif

ifdef SUBDIRS
$(foreach @loadee,$(SUBDIRS),$(smart.load))
endif #SUBDIRS

ifdef SOURCES
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
  modules: $(PROGRAMS)
  $(PROGRAMS): $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LOADLIBS)
endif #PROGRAMS

ifdef LIBRARIES
  LIBRARIES := $(LIBRARIES:%=$(SRCDIR)/%)
  LIBRARIES.a := $(filter %.a,$(LIBRARIES))
  LIBRARIES.so := $(filter %.so,$(LIBRARIES))
  modules: $(LIBRARIES.a) $(LIBRARIES.so)
  $(LIBRARIES.a): $(OBJECTS)
	$(AR) $(ARFLAGS) $@ $^ $(LIBADD)
  $(LIBRARIES.so): $(OBJECTS)
	$(CXX) $(LDFLAGS) -shared -o $@ $^ $(LOADLIBS)
endif #LIBRARIES

COMPILE.c++ = $(CXX) $(CXXFLAGS) -c -o $@ $<
COMPILE.c = $(CC) $(CFLAGS) -c -o $@ $<

$(SOURCES.cpp:%.cpp=%.o):%.o:%.cpp ; $(COMPILE.c++)
$(SOURCES.c:%.c=%.o):%.o:%.c ; $(COMPILE.c)

$(eval clean-$(SM.MK): ; \
  rm -vf $(strip $(LIBRARIES) $(PROGRAMS) $(OBJECTS)))

clean: clean-$(SM.MK)

endif #SOURCES
