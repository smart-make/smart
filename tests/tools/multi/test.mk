discard := $(test-log-visit)
$(call smart.test.assert.value,TOOL,test)
$(call smart.test.assert.value,NAMES, multi test test-1 test-2)
