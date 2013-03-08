#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

PACKAGE := $(PACKAGE:%=$(SRCDIR)/%)

$(warning jar: $(PACKAGE))
