$(smart.internal)

smart~android_files := $(wildcard $(SRCDIR)/AndroidManifest.xml)
ifdef smart~android_files
  TOOL := android
endif

smart~android_files := $(wildcard $(SRCDIR)/Android.mk $(SRCDIR)/jni/Android.mk)
ifdef smart~android_files
  TOOL := android
endif #smart~android_files

smart~android_files :=
