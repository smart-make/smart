$(smart.internal)

ifndef ANDROID.ndk
  ANDROID.ndk := $(patsubst %/,%,$(dir $(shell which ndk-build)))
  ANDROID.clearvars = $(smart.tooldir)/ndkbuild/clearvars.mk
  ANDROID.build_static = $(smart.tooldir)/ndkbuild/static.mk
  ANDROID.build_shared = $(smart.tooldir)/ndkbuild/shared.mk
  ANDROID.build_executable = $(smart.tooldir)/ndkbuild/executable.mk
endif #ANDROID.ndk
