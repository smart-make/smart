#$(foreach @loadee,$(SUBDIRS),$(info 1:$(@loadee))$(smart.load)$(info 2:$(@loadee)))
$(foreach @loadee,$(SUBDIRS),$(smart.load))
