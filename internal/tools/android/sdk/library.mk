#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

# aapt crunch -S $(SRCDIR)/res -C $(OUT)/$(NAME)/res
$(OUT)/$(NAME): $(OUT)/$(NAME)/classes $(OUT)/$(NAME)/res

$(OUT)/$(NAME)/res: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/res: command = $(aapt) crunch -S $< -C $@
$(OUT)/$(NAME)/res: $(SRCDIR)/res
	@mkdir -p $@
	$(command)

$(OUT)/$(NAME)/sources: aapt := $(ANDROID.aapt)
$(OUT)/$(NAME)/sources: manifest := $(SRCDIR)/AndroidManifest.xml
$(OUT)/$(NAME)/sources: libs := $(LIBS.java) $(ANDROID_PLATFORM_LIB)
$(OUT)/$(NAME)/sources: assets := $(wildcard $(SRCDIR)/assets) $(ASSETS)
$(OUT)/$(NAME)/sources: reses := $(wildcard $(SRCDIR)/res) $(RES)
$(OUT)/$(NAME)/sources: out := $(OUT)/$(NAME)
$(OUT)/$(NAME)/sources: command = \
	$(aapt) package --non-constant-id -f -m \
	--output-text-symbols "$(@D)" \
	$(addprefix -M ,$(wildcard $(manifest))) \
	$(foreach 1,$(libs),-I "$1") \
	$(foreach 1,$(reses),-S "$1") \
	$(foreach 1,$(assets),-A "$1") \
	-J "$(out)/sources" --generate-dependencies \
	-P "$(out)/public.xml" \
	-G "$(out)/proguard.txt"
$(OUT)/$(NAME)/sources: $(OUT)/$(NAME)/res
	@mkdir -p $@
	$(command)

$(OUT)/$(NAME)/sources/.list: $(OUT)/$(NAME)/sources
	@mkdir -p $(@D)
	@find $< -type f -name '*.java' > $@

-include $(OUT)/$(NAME)/sources/R.java.d
$(OUT)/$(NAME)/classes: bootclass := $(ANDROID_PLATFORM_LIB)
$(OUT)/$(NAME)/classes: sourcepath := $(OUT)/$(NAME)/sources
$(OUT)/$(NAME)/classes: sources := $(OUT)/$(NAME)/sources/.list
$(OUT)/$(NAME)/classes: out := $(OUT)/$(NAME)/classes
$(OUT)/$(NAME)/classes: command = \
	javac -d $(out) $(if $(DEBUG),-g) \
	-encoding "UTF-8" -source 1.5 -target 1.5 \
	-bootclasspath "$(bootclass)" \
	-sourcepath "$(sourcepath)" \
	"@$(sources)"

$(OUT)/$(NAME)/classes: $(OUT)/$(NAME)/sources/.list
	@mkdir -p $@
	$(command)

$(warning jar: $(NAME) $(TOOL) $(SRCDIR))
