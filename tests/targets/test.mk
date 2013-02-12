#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(foreach 1,\
    ./smart \
    , $(call smart.test.assert.equal,$(filter $1,$(smart.list)),$1))
