$(smart.internal)

ifndef ANDROID.ndk
  ANDROID.ndk := $(patsubst %/,%,$(dir $(shell which ndk-build)))
  ANDROID.clearvars = $(smart.root)/internal/tools/android/ndkbuild/clearvars.mk
  ANDROID.build_static = $(smart.root)/internal/tools/android/ndkbuild/static.mk
  ANDROID.build_shared = $(smart.root)/internal/tools/android/ndkbuild/shared.mk
  ANDROID.build_executable = $(smart.root)/internal/tools/android/ndkbuild/executable.mk
endif #ANDROID.ndk
