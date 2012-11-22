$(smart.internal)

ifndef ANDROID.ndk
  ANDROID.ndk := $(patsubst %/,%,$(dir $(shell which ndk-build)))
  ANDROID.clearvars = $(smart.root)/internal/android/ndk/clearvars.mk
  ANDROID.build_static = $(smart.root)/internal/android/ndk/buildstatic.mk
  ANDROID.build_shared = $(smart.root)/internal/android/ndk/buildshared.mk
  ANDROID.build_executable = $(smart.root)/internal/android/ndk/buildexecutable.mk
endif #ANDROID.ndk
