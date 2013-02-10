smart~android_files := $(wildcard $(SRCDIR)/AndroidManifest.xml)
ifdef smart~android_files
  TOOL := android
  ifndef ANDROID.root
    include $(smart.tooldir)/init.mk
  endif #ANDROID.root
  ANDROID_ROOT = $(ANDROID.root)
  ANDROID_EXTRAS = $(ANDROID.root)/extras
  APK := $(NAME).apk
endif

smart~android_files := $(wildcard $(SRCDIR)/Android.mk $(SRCDIR)/jni/Android.mk)
ifdef smart~android_files
  TOOL := android
  ifndef ANDROID.ndk
    include $(smart.tooldir)/ndkbuild/init.mk
  endif #ANDROID.ndk
  ANDROID_NDK = $(ANDROID.ndk)
  NDK_BUILD := $(firstword $(smart~android_files))
  NDK_APPLICATION_MK := $(wildcard $(dir $(NDK_BUILD))Application.mk)
  ifdef NDK_APPLICATION_MK
    include $(NDK_APPLICATION_MK)
  endif #NDK_APPLICATION_MK

  ifeq ($(APP_OPTIM),debug)
    NDK_DEBUG := 1
  else
    NDK_DEBUG := 0
  endif

  NDK_VERBOSE :=
  NDK_BUILD := $(NDK_BUILD:$(SRCDIR)/%=%)

  APP_ABI := $(or $(APP_ABI),armeabi)
endif #smart~android_files

smart~android_files :=
