TOOL := android/sdk
SRCDIR := $(ANDROID_COMPAT)/v4
MANIFEST := $(wildcard $(SRCDIR)/AndroidManifest.xml)
PACKAGE := $(if $(MANIFEST),$(shell awk -f $(smart.tooldir)/extract-package-name.awk $(MANIFEST)))
EXPORT.LIBS := $(SRCDIR)/android-support-v4.jar
