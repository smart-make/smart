ifneq ($(wildcard $(SRCDIR)/AndroidManifest.xml),)
  ifndef ANDROID.root
    include $(smart.root)/internal/android/init.mk
  endif #ANDROID.root
  ANDROID_ROOT = $(ANDROID.root)
endif
