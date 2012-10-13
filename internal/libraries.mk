LIBRARIES := $(LIBRARIES:%=$(SRCDIR)/%)
LIBRARIES.a := $(filter %.a,$(LIBRARIES))
LIBRARIES.so := $(filter %.so,$(LIBRARIES))

modules: $(LIBRARIES.a) $(LIBRARIES.so)

$(eval $(LIBRARIES.a): $(OBJECTS) ; \
	$(AR) $(ARFLAGS) $$@ $$^ $(LIBADD))
$(eval $(LIBRARIES.so): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -shared -o $$@ $$^ $(LOADLIBS))
