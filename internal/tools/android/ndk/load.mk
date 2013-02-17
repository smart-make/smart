$(smart.internal)

my-dir = $(smart.me)
CLEAR_VARS = $(ANDROID.clearvars)
BUILD_STATIC_LIBRARY = $(ANDROID.build_static)
BUILD_SHARED_LIBRARY = $(ANDROID.build_shared)
BUILD_EXECUTABLE = $(ANDROID.build_executable)

## reset NDK_EXPORT
NDK_EXPORT :=

include $(NDK_BUILD)

ifdef NDK_EXPORT
 NDK_EXPORT := $(PWD)/$(OUT:$(ROOT)/%=%)/.export
 $(NDK_EXPORT)/$(NAME)/Android.mk : $(OUT)/.export/$(NAME)/Android.mk ; @test $@
 $(call smart.set,$(NAME),NDK_EXPORT,$(NDK_EXPORT))
endif #NDK_EXPORT

NDK_BUILD_TARGETS := $(NDK_BUILD_TARGETS:%=$(SRCDIR)/%)

ifdef REQUIRES
define smart~add_module_path
$(eval \
  ifeq ($(findstring :$i:,$(NDK_MODULE_PATH):),)
    NDK_MODULE_PATH := $(NDK_MODULE_PATH):$i
    $(NDK_BUILD_TARGETS) : $i/$(call smart.get,$m,NAME)/Android.mk
  endif
 )
endef #smart~add_module_path
 $(foreach m,$(REQUIRES), $(foreach i,$(call smart.get,$m,NDK_EXPORT),\
     $(smart~add_module_path)))
 $(warning NDK_MODULE_PATH: $(NDK_MODULE_PATH))
endif #REQUIRES
