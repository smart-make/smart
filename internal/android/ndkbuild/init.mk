$(smart.internal)

ifndef ANDROID.ndk
  ANDROID.ndk := $(patsubst %/,%,$(dir $(shell which ndk-build)))
  ANDROID.clearvars = $(smart.root)/internal/android/ndkbuild/clearvars.mk
  ANDROID.build_static = $(smart.root)/internal/android/ndkbuild/buildstatic.mk
  ANDROID.build_shared = $(smart.root)/internal/android/ndkbuild/buildshared.mk
  ANDROID.build_executable = $(smart.root)/internal/android/ndkbuild/buildexecutable.mk
endif #ANDROID.ndk
