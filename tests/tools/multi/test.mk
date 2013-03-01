discard := $(test-log-visit)
discard := $(shell echo "$(NAMES)" > names.log)
$(call smart.test.assert.value,TOOL,test)
$(call smart.test.assert.value,NAMES, multi test test-1 test-2 android sdk:sdk.apk ndk)
