$(smart.internal)

## NDK_BUILD is APP_BUILD_SCRIPT, e.g. Android.mk
NDK_BUILD := $(NDK_BUILD:%=$(SRCDIR)/%)
NDK_TOOLCHAIN_VERSION := $(or $(NDK_TOOLCHAIN_VERSION),$(TOOLCHAIN_VERSION),$(DEFAULT_TOOLCHAIN_VERSION))

## load Android.mk
include $(smart.tooldir)/ndk/load.mk

#$(warning $(NAME): $(NDK_BUILD_TYPE): $(NDK_BUILD_TARGETS))

ifneq ($(NDK_VERBOSE),1)
  ifneq ($(NDK_VERBOSE),true)
    NDK_VERBOSE :=
  endif
endif

#$(warning $(MAKE))
#$(warning $(SRCDIR))
#$(warning $(NDK_BUILD))
#$(warning $(LOCAL_SRC_FILES:%=$(dir $(NDK_BUILD))%))

# $$(MAKE)
# $(smart.tooldir)/ndk/build.mk
#	$(if $(APP_ABI),APP_ABI="$(APP_ABI)")
define smart~rules-ndk
  $(NDK_BUILD_TARGETS): $(OUT)/$(NAME)/.ndk/built
  $(OUT)/$(NAME)/.ndk/built: \
    $(wildcard \
      $(LOCAL_SRC_FILES:%=$(dir $(NDK_BUILD))%) \
      $(dir $(NDK_BUILD))/*.h \
      $(dir $(NDK_BUILD))/Android.mk \
      $(dir $(NDK_BUILD))/Application.mk \
     )
	make -f $(ANDROID.ndk)/build/core/build-local.mk -C $(SRCDIR) \
	APP_BUILD_SCRIPT="$(NDK_BUILD)" \
	APP_MODULES="$(LOCAL_MODULE)" \
	$(if $(NDK_APPLICATION_MK),NDK_APPLICATION_MK="$(NDK_APPLICATION_MK)") \
	$(if $(NDK_TOOLCHAIN_VERSION),NDK_TOOLCHAIN_VERSION="$(NDK_TOOLCHAIN_VERSION)") \
	$(if $(NDK_MODULE_PATH),NDK_MODULE_PATH="$(NDK_MODULE_PATH)") \
	$(if $(NDK_DEBUG),NDK_DEBUG=$(NDK_DEBUG)) \
	$(if $(NDK_VERBOSE),V=$(NDK_VERBOSE)) \
	NDK_PROJECT_PATH="."
	@(mkdir -p $$(@D) && echo "targets = $(NDK_BUILD_TARGETS)" > $$@)
endef #smart~rules-ndk
ifdef NDK_BUILD_TARGETS
  $(eval $(smart~rules-ndk))
endif #NDK_BUILD_TARGETS

smart~rules-ndk :=
