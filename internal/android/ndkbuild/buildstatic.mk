NDK_BUILD_TYPE := static
NDK_BUILD_TARGETS :=
$(foreach 1,$(APP_ABI),$(eval NDK_BUILD_TARGETS += obj/local/$1/lib$(LOCAL_MODULE).a))
