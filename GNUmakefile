bin/smart: src/smart.c
	@mkdir -p $(@D)
	gcc -O2 -static -o $@ $^
install: /usr/bin/smart
/usr/bin/smart: bin/smart
	@echo "Installing $@..."
	@if test -f $@; then echo "$@ existed" && false; fi
	@echo "#!/bin/bash" > $@
	@echo 'exec $(CURDIR)/bin/smart "$$@"' >> $@
.PHONY: install
