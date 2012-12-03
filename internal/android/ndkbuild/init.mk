$(smart.internal)

ifndef ANDROID.ndk
  ANDROID.ndk := $(patsubst %/,%,$(dir $(shell which ndk-build)))
  ANDROID.clearvars = $(smart.root)/internal/android/ndkbuild/clearvars.mk
  ANDROID.build_static = $(smart.root)/internal/android/ndkbuild/static.mk
  ANDROID.build_shared = $(smart.root)/internal/android/ndkbuild/shared.mk
  ANDROID.build_executable = $(smart.root)/internal/android/ndkbuild/executable.mk
endif #ANDROID.ndk
