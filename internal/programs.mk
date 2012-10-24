$(smart.internal)

PROGRAMS := $(PROGRAMS:%=$(SRCDIR)/%)

$(call smart~unique,LDFLAGS)

$(eval $(PROGRAMS): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -o $$@ $$^ $(LOADLIBS))
