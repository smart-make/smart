$(smart.internal)

PROGRAM := $(PROGRAM:%=$(SRCDIR)/%)
PROGRAM := $(PROGRAM:%.exe=%).exe

$(call smart~unique,LDFLAGS)

$(eval $(PROGRAM): $(OBJECTS) ; \
	$(TOOLPREFIX)g++ $(LDFLAGS) -o $$@ $$^ $(smart~LDLIBS))
