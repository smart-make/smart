$(smart.internal)

PROGRAMS := $(PROGRAMS:%=$(SRCDIR)/%)

$(eval $(PROGRAMS): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -o $$@ $$^ $(LOADLIBS))
