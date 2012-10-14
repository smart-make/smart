#$(foreach @loadee,$(SUBDIRS),$(smart.load))
$(foreach @loadee,$(SUBDIRS),$(eval include $(smart.root)/funs/smart.load))
