TOOL := android/sdk
SRCDIR := $(ANDROID_EXTRAS)/google/admob_ads_sdk
MANIFEST := $(wildcard $(SRCDIR)/AndroidManifest.xml)
PACKAGE := $(if $(MANIFEST),$(shell awk -f $(smart.tooldir)/extract-package-name.awk $(MANIFEST)))
EXPORT.LIBS := $(SRCDIR)/GoogleAdMobAdsSdk-6.4.1.jar
