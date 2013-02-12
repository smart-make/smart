#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(foreach 1,\
    ./smart \
    ./leaf-1/smart \
    ./leaf-1/leaf-1-1/smart \
    ./leaf-1/leaf-1-1/leaf-1-1-1/smart \
    ./leaf-1/leaf-1-1/leaf-1-1-2/smart \
    ./leaf-1/leaf-1-1/leaf-1-1-3/smart \
    ./leaf-1/leaf-1-2/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-1/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-2/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-2/leaf-1-2-2-1/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-2/leaf-1-2-2-2/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-2/leaf-1-2-2-3/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-3/smart \
    ./leaf-1/leaf-1-3/smart \
    ./leaf-2/smart \
    ./leaf-2/leaf-2-1/smart \
    ./leaf-2/leaf-2-2/smart \
    ./leaf-2/leaf-2-3/smart \
    ./leaf-3/smart \
    ./leaf-3/leaf-3-1/smart \
    ./leaf-3/leaf-3-2/smart \
    ./leaf-3/leaf-3-3/smart \
    , $(call smart.test.assert.equal,$(filter $1,$(smart.list)),$1))
