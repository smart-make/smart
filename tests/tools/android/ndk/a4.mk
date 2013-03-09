APP_PLATFORM := android-9
APP_ABI := x86 mips
APP_OPTIM := debug
PROGRAM := ndktest
SOURCES := a4.c
MODULE_PATH := $(dir $(PWD))modules
IMPORTS := foo_app_glue
USE_MODULES := foo_app
