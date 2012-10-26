$(smart.internal)

LIBRARIES := $(LIBRARIES:%=$(SRCDIR)/%)
LIBRARIES.a := $(filter %.a,$(LIBRARIES))
LIBRARIES.so := $(filter %.so,$(LIBRARIES))

ifneq ($(filter-out $(LIBRARIES),$(LIBRARIES.a) $(LIBRARIES.so)),)
  $(error unregonized libraries "$(filter-out $(LIBRARIES),$(LIBRARIES.a) $(LIBRARIES.so))")
endif

$(call smart~unique,ARFLAGS)
$(call smart~unique,LDFLAGS)

$(eval $(LIBRARIES.a): $(OBJECTS) ; \
	$(AR) $(ARFLAGS) $$@ $$^)
$(eval $(LIBRARIES.so): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -shared -o $$@ $$^ $(LDLIBS))
