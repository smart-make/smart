NDK_BUILD_TYPE := shared
NDK_BUILD_TARGETS :=
$(foreach 1,$(APP_ABI),$(eval NDK_BUILD_TARGETS += libs/$1/lib$(LOCAL_MODULE).so))
