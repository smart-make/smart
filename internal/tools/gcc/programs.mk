$(smart.internal)

PROGRAM := $(PROGRAM:%=$(SRCDIR)/%)

$(call smart~unique,LDFLAGS)

$(eval $(PROGRAM): $(OBJECTS) ; \
	$(CXX) $(LDFLAGS) -o $$@ $$^ $(smart~LDLIBS))
