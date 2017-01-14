LIBRARY := yes
TOOL := android/sdk
SRCDIR := $(ANDROID_EXTRAS)/google/google_play_services/libproject/google-play-services_lib
MANIFEST := $(wildcard $(SRCDIR)/AndroidManifest.xml)
PACKAGE := $(if $(MANIFEST),$(shell awk -f $(smart.tooldir)/extract-package-name.awk $(MANIFEST)))
EXPORT.LIBS := $(SRCDIR)/libs/google-play-services.jar
