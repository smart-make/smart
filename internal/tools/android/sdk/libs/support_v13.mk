TOOL := android/sdk
SRCDIR := $(ANDROID_COMPAT)/v13
MANIFEST := $(wildcard $(SRCDIR)/AndroidManifest.xml)
PACKAGE := $(if $(MANIFEST),$(shell awk -f $(smart.tooldir)/extract-package-name.awk $(MANIFEST)))
EXPORT.LIBS := $(SRCDIR)/android-support-v13.jar
