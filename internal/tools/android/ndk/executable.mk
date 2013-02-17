NDK_BUILD_TYPE := executable
NDK_BUILD_TARGETS :=
$(foreach 1,$(APP_ABI),$(eval NDK_BUILD_TARGETS += libs/$1/$(LOCAL_MODULE)))
