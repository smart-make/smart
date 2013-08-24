SRCDIR := $(ANDROID_COMPAT)/v7/appcompat
TOOL := android/sdk
LIBRARY := yes

#$(warning $(NAME): $(TOOL), $(SRCDIR))

EXPORT.LIBS := $(SRCDIR)/libs/android-support-v7-appcompat.jar
#EXPORT.RES := $(OUT)/$(NAME)/res
#EXPORT.RES := $(SRCDIR)/res
