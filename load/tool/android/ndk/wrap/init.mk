$(smart.internal)

ifndef ANDROID.ndk
  ANDROID.ndk := $(patsubst %/,%,$(dir $(shell which ndk-build)))
  ANDROID.clearvars = $(smart.tooldir)/ndk/clearvars.mk
  ANDROID.build_static = $(smart.tooldir)/ndk/static.mk
  ANDROID.build_shared = $(smart.tooldir)/ndk/shared.mk
  ANDROID.build_executable = $(smart.tooldir)/ndk/executable.mk
endif #ANDROID.ndk
