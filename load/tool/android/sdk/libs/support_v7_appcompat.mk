LIBRARY := yes
TOOL := android/sdk
SRCDIR := $(ANDROID_COMPAT)/v7/appcompat
MANIFEST := $(wildcard $(SRCDIR)/AndroidManifest.xml)
PACKAGE := $(if $(MANIFEST),$(shell awk -f $(smart.tooldir)/extract-package-name.awk $(MANIFEST)))
EXPORT.LIBS := $(SRCDIR)/libs/android-support-v7-appcompat.jar
