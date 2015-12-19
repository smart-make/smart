#
#    Copyright (C) 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

## Initialize build environment for library.mk and program.mk.

smart~CFLAGS   := $(TARGET_CFLAGS) $(CFLAGS)
smart~CXXFLAGS := $(TARGET_CXXFLAGS) $(CXXFLAGS)
smart~CPPFLAGS := $(TARGET_CPPFLAGS) $(CPPFLAGS)
smart~INCLUDES := $(TARGET_C_INCLUDES) $(INCLUDES)
smart~DEFINES  := -DANDROID -D__ANDROID__ $(DEFINES)
smart~ARFLAGS  := $(TARGET_ARFLAGS) $(ARFLAGS)
smart~LDFLAGS  := $(TARGET_LDFLAGS) $(LDFLAGS)
smart~LDLIBS   := $(TARGET_LDLIBS) $(LDLIBS)
smart~OBJS     := $(OBJECTS)
smart~LIBS     := $(TARGET_LIBS) $(LIBS)
smart~DEPS     :=
smart~CPP_FEATURES := $(CPP_FEATURES)

## Compute FULLLIBS
ifdef FULLLIBS
  smart~LDLIBS += -Wl,--whole-archive $(sort $(FULLLIBS))
  smart~LDLIBS += -Wl,--no-whole-archive $(LOADLIBS) $(LIBADD)
else
  smart~LDLIBS += $(LOADLIBS) $(LIBADD)
endif #FULLLIBS

## We need to filter out the .native from the list.
smart~LIBS := $(filter-out %.native,$(smart~LIBS))

ifneq ($(ALLOW_UNDEFINED_SYMBOLS),true)
  smart~LDFLAGS += $(TARGET_NO_UNDEFINED_LDFLAGS)
endif

#$(warning $(smart~m): $(__ndk_modules.$(smart~m).BUILT_MODULE))

############################################################
##
##  Computation base on Android NDK's USE_MODULES.
##
define smart~use~STATIC_LIBRARY
$(eval \
  #smart~LDLIBS += $(__ndk_modules.$(smart~m).BUILT_MODULE)
 )
endef #smart~use~STATIC_LIBRARY

define smart~use~SHARED_LIBRARY
$(eval \
  #smart~LDLIBS += $(__ndk_modules.$(smart~m).BUILT_MODULE)
 )
endef #smart~use~SHARED_LIBRARY

define smart~use~PREBUILT_STATIC_LIBRARY
$(eval \
  #smart~LDLIBS += $(__ndk_modules.$(smart~m).OBJECTS)
  smart~LDLIBS += $(call module-get-built,$(smart~m))
 )
endef #smart~use~PREBUILT_STATIC_LIBRARY

define smart~use~PREBUILT_SHARED_LIBRARY
$(eval \
  #smart~LDLIBS += $(__ndk_modules.$(smart~m).OBJECTS)
  smart~LDLIBS += $(call module-get-built,$(smart~m))
 )
endef #smart~use~PREBUILT_SHARED_LIBRARY

## Recursive computation base on USE_MODULES
define smart~use
$(call smart~use~$(call module-get-class,$(smart~m)))\
$(eval \
  smart~CFLAGS   += $(call smart~var~export,CFLAGS)
  smart~CXXFLAGS += $(call smart~var~export,CXXFLAGS)
  smart~CPPFLAGS += $(call smart~var~export,CPPFLAGS)
  smart~LDFLAGS  += $(call smart~var~export,LDFLAGS)
  smart~LDLIBS   += $(call smart~var~export,LDLIBS)
  smart~INCLUDES += $(call smart~var~export,INCLUDES)
  smart~OBJS     += $(call smart~var~export,OBJECTS)
  ifneq ($(filter -l$(smart~m),$(call smart~var~export,LDLIBS)),)
    smart~LDFLAGS += -L$(TARGET_OUT)
    smart~DEPS   += $(addprefix $(TARGET_OUT)/,$(call smart~var,LIBRARY))
  else
    smart~LIBS   += $(addprefix $(TARGET_OUT)/,$(call smart~var,LIBRARY))
  endif
  smart~CPP_FEATURES += $(call smart~var~export,CPP_FEATURES)
 )$(foreach smart~m,$(call smart~var,USE_MODULES),$(call smart~use))
endef #smart~use

## Apply USE_MODULES recursively.
$(foreach smart~m, $(USE_MODULES) \
    $(NDK_STL.$(APP_STL).STATIC_LIBS:lib%=%) \
    $(NDK_STL.$(APP_STL).SHARED_LIBS:lib%=%) \
 ,$(smart~use))

############################################################
##
## Also compute REQUIRES variable for LIBRARY dependencies.
## 
## The REQUIRES variable had already been calculated by "smart" base system,
## but we do this again just for LIBRARY dependencies.
##
##  TODO: do recursive for static library, non-recursive for shared library
##
define smart~req
$(foreach lib,$(call smart~var,LIBRARY),$(eval \
   smart~LIBS += $(TARGET_OUT)/$(lib)
 ))$(foreach smart~m,$(call smart~var,REQUIRES),$(call smart~req))\
   $(foreach smart~m,$(call smart~var,USE_MODULES),$(call smart~use))
endef #smart~req
$(foreach smart~m,$(REQUIRES),$(smart~req))

smart~use =
smart~req =

###########################################################
##
## More specific features
##

#$(warning $(NDK_STL.$(APP_STL).IMPORT_MODULE))
#$(warning $(NDK_STL.$(APP_STL).STATIC_LIBS))
#$(warning $(NDK_STL.$(APP_STL).SHARED_LIBS))
#$(warning $(__ndk_modules.$(APP_STL).OBJECTS))
#$(warning $(call module-get-built,$(APP_STL)))

smart~optimize~debug~CFLAGS := -g -ggdb \
    $(TARGET_$(ARM_MODE)_$(APP_OPTIM)_CFLAGS)
smart~optimize~release~CFLAGS := -O2 \
    $(TARGET_$(ARM_MODE)_$(APP_OPTIM)_CFLAGS)

smart~optimize~debug~LDFLAGS := \
    $(TARGET_$(ARM_MODE)_$(APP_OPTIM)_LDFLAGS)
smart~optimize~release~LDFLAGS := -Wl,--strip-all \
    $(TARGET_$(ARM_MODE)_$(APP_OPTIM)_LDFLAGS)

$(foreach v,smart~CPPFLAGS smart~CXXFLAGS smart~CFLAGS,\
    $(eval $v := $(filter-out -O% -g -ggdb,$($v))))
smart~CFLAGS := $(smart~optimize~$(APP_OPTIM)~CFLAGS) $(smart~CFLAGS)

ifeq ($(ARM_NEON),true)
  smart~CFLAGS := $(TARGET_CFLAGS.neon) $(smart~CFLAGS)
endif

smart~CPP_FEATURES := $(sort $(smart~CPP_FEATURES))

smart~has~rtti := $(strip $(or \
  $(call module-has-c++-features,$(NAME),rtti),\
  $(if $(filter rtti,$(smart~CPP_FEATURES)),true)))

smart~has~exceptions := $(strip $(or \
  $(call module-has-c++-features,$(NAME),exceptions),\
  $(if $(filter exceptions,$(smart~CPP_FEATURES)),true)))

ifneq (,$(smart~has~rtti))
  smart~CFLAGS := $(filter-out -fno-rtti,$(smart~CFLAGS))
  smart~CXXFLAGS := $(filter-out -fno-rtti,$(smart~CXXFLAGS))
  smart~CPPFLAGS := $(filter-out -fno-rtti,$(smart~CPPFLAGS))
  smart~CPPFLAGS += -frtti
endif
ifneq (,$(smart~has~exceptions))
  smart~CFLAGS := $(filter-out -fno-exceptions,$(smart~CFLAGS))
  smart~CXXFLAGS := $(filter-out -fno-exceptions,$(smart~CXXFLAGS))
  smart~CPPFLAGS := $(filter-out -fno-exceptions,$(smart~CPPFLAGS))
  smart~CPPFLAGS += -fexceptions
endif

#$(warning $(NAME): $(smart~has~rtti) $(smart~has~exceptions))

smart~LDFLAGS := $(filter-out -shared,$(smart~LDFLAGS)) \
    $(smart~optimize~$(APP_OPTIM)~LDFLAGS)
smart~LDLIBS := $(strip $(smart~LDLIBS) $(TARGET_LDLIBS))

ifneq (,$(call module-has-c++-features,$(NAME),rtti exceptions))
  ifeq (system,$(APP_STL))
    smart~LDLIBS += $(call host-path,$(NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAIN_VERSION)/libs/$(TARGET_ARCH_ABI)/libsupc++$(TARGET_LIB_EXTENSION))
  endif
endif

smart~LDLIBS += $(TARGET_LIBGCC)

## Remove useless spaces. 
$(foreach 1,\
	smart~CFLAGS \
	smart~CXXFLAGS \
	smart~CPPFLAGS \
	smart~INCLUDES \
	smart~DEFINES \
	smart~ARFLAGS \
	smart~LDFLAGS \
	smart~LDLIBS \
	smart~OBJS \
	smart~LIBS \
 ,$(eval $1 := $(foreach 2,$($1),$2)))

#$(warning $(NAME): $(APP_STL): $(smart~CXXFLAGS))
#$(warning $(NAME): $(APP_STL): $(smart~INCLUDES))
#$(warning $(NAME): $(TARGET_OUT): $(smart~LIBS))
