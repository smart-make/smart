$(smart.internal)

NDK_BUILD := $(NDK_BUILD:%=$(SRCDIR)/%)
NDK_TOOLCHAIN_VERSION := $(or $(NDK_TOOLCHAIN_VERSION),4.6)
export NDK_TOOLCHAIN_VERSION
ifdef NDK_MODULE_PATH
  export NDK_MODULE_PATH
endif

my-dir = $(smart.me)
CLEAR_VARS = $(ANDROID.clearvars)
BUILD_STATIC_LIBRARY = $(ANDROID.build_static)
BUILD_SHARED_LIBRARY = $(ANDROID.build_shared)
BUILD_EXECUTABLE = $(ANDROID.build_executable)
include $(NDK_BUILD)

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
      $(SRCDIR)/*.mk \
     ) $(smart.root)/internal/android/ndkbuild.mk
	$$(MAKE) -f $(ANDROID.ndk)/build/core/build-local.mk -C $(SRCDIR) \
	APP_BUILD_SCRIPT="$(NDK_BUILD:$(SRCDIR)/%=%)" \
	APP_MODULES=$(LOCAL_MODULE) \
	$(if $(APP_ABI),APP_ABI="$(APP_ABI)") \
	$(if $(NDK_APPLICATION_MK),NDK_APPLICATION_MK="$(NDK_APPLICATION_MK)") \
	$(if $(NDK_DEBUG),NDK_DEBUG=$(NDK_DEBUG)) \
	$(if $(NDK_VERBOSE),V=$(NDK_VERBOSE)) \
	NDK_PROJECT_PATH="." \
	&& (mkdir -p $$(@D) && echo "$(NDK_BUILD_TARGETS)" > $$@)
  $(NDK_BUILD_TARGETS): $(OUT)/$(NAME)/.ndkbuilt
endef #smart~rules-ndk
ifdef NDK_BUILD_TARGETS
  $(eval $(smart~rules-ndk))
endif #NDK_BUILD_TARGETS

smart~rules-ndk :=