$(smart.internal)

LIBRARY := $(LIBRARY:%=$(SRCDIR)/%)
LIBRARY.a := $(filter %.a,$(LIBRARY))
LIBRARY.so := $(filter %.so,$(LIBRARY))

ifneq ($(filter-out $(LIBRARY),$(LIBRARY.a) $(LIBRARY.so)),)
  $(error unregonized libraries "$(filter-out $(LIBRARY),$(LIBRARY.a) $(LIBRARY.so))")
endif

$(call smart~unique,ARFLAGS)
$(call smart~unique,LDFLAGS)

ifdef LIBRARY.a
$(eval $(LIBRARY.a): $(OBJECTS) ; \
	$(AR) $(ARFLAGS) $$@ $$^)
endif #LIBRARY.a

ifdef LIBRARY.so
$(eval $(LIBRARY.so): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -shared -o $$@ $$^ $(LDLIBS))
endif #LIBRARY.so
