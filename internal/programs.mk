PROGRAMS := $(PROGRAMS:%=$(SRCDIR)/%)
modules: $(PROGRAMS)
$(eval $(PROGRAMS): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -o $$@ $$^ $(LOADLIBS))
