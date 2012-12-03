$(smart.internal)

## NDK_BUILD is APP_BUILD_SCRIPT, e.g. Android.mk
NDK_BUILD := $(NDK_BUILD:%=$(SRCDIR)/%)
NDK_TOOLCHAIN_VERSION := $(or $(NDK_TOOLCHAIN_VERSION),4.6)

## load Android.mk
include $(smart.root)/internal/android/ndkbuild/a.mk

#$(warning $(NAME): $(NDK_BUILD_TYPE): $(NDK_BUILD_TARGETS))

ifneq ($(NDK_VERBOSE),1)
  ifneq ($(NDK_VERBOSE),true)
    NDK_VERBOSE :=
  endif
endif

define smart~rules-ndk
  $(OUT)/$(NAME)/.ndkbuilt: \
    $(wildcard \
      $(SRCDIR)/*.c $(SRCDIR)/*.h \
      $(SRCDIR)/Android.mk $(SRCDIR)/Application.mk \
     ) $(smart.root)/internal/android/ndkbuild.mk
	@$$(MAKE) -f $(ANDROID.ndk)/build/core/build-local.mk -C $(SRCDIR) \
	APP_BUILD_SCRIPT="$(NDK_BUILD:$(SRCDIR)/%=%)" \
	APP_MODULES="$(LOCAL_MODULE)" \
	$(if $(APP_ABI),APP_ABI="$(APP_ABI)") \
	$(if $(NDK_APPLICATION_MK),NDK_APPLICATION_MK="$(NDK_APPLICATION_MK)") \
	$(if $(NDK_TOOLCHAIN_VERSION),NDK_TOOLCHAIN_VERSION="$(NDK_TOOLCHAIN_VERSION)") \
	$(if $(NDK_MODULE_PATH),NDK_MODULE_PATH="$(NDK_MODULE_PATH)") \
	$(if $(NDK_DEBUG),NDK_DEBUG=$(NDK_DEBUG)) \
	$(if $(NDK_VERBOSE),V=$(NDK_VERBOSE)) \
	NDK_PROJECT_PATH="."
	@(mkdir -p $$(@D) && echo "targets = $(NDK_BUILD_TARGETS)" > $$@)
  $(NDK_BUILD_TARGETS): $(OUT)/$(NAME)/.ndkbuilt
endef #smart~rules-ndk
ifdef NDK_BUILD_TARGETS
  $(eval $(smart~rules-ndk))
endif #NDK_BUILD_TARGETS

smart~rules-ndk :=
