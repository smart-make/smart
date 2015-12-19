TOOL := android/sdk
SRCDIR := $(ANDROID_EXTRAS)/google/analytics_sdk_v2
MANIFEST := $(wildcard $(SRCDIR)/AndroidManifest.xml)
PACKAGE := $(if $(MANIFEST),$(shell awk -f $(smart.tooldir)/extract-package-name.awk $(MANIFEST)))
EXPORT.LIBS := $(SRCDIR)/libGoogleAnalyticsV2.jar
