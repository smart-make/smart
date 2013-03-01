$(smart.internal)
$(foreach @loadee,$(MODULES),$(eval include $(smart.root)/funs/smart.load))
