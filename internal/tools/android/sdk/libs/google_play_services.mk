SRCDIR := $(ANDROID_EXTRAS)/google/google_play_services/libproject/google-play-services_lib
TOOL := android/sdk
LIBRARY := yes

# $(warning $(NAME): $(TOOL), $(SRCDIR))

EXPORT.LIBS := $(SRCDIR)/libs/google-play-services.jar
#EXPORT.RES := $(OUT)/$(NAME)/res $(SRCDIR)/res
EXPORT.RES := $(OUT)/$(NAME)/res
