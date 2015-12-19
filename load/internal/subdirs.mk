$(smart.internal)
$(foreach @loadee,$(SUBDIRS),$(eval include $(smart.root)/funs/smart.load))
