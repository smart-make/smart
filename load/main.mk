#
#    Copyright (C) 2012-2015, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#------------------------------------------------------------
#
#  Name Rules:
#    1) internal global variables: smart.*
#    2) internal callables: smart~*
#    3) internal iterator: @*
#
## Optimize for reentrance in cases like "include file.d".
ifeq ($(words $(MAKEFILE_LIST)),1)
  smart.me = $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
  smart.root := $(smart.me)
  smart.reentrance :=
else
  smart.reentrance := true
endif

ifneq ($(smart.reentrance),true)
  MAKEFILE_LIST :=
  include $(smart.root)/run.mk
else
  $(info smart: skipped reentrance)
endif
