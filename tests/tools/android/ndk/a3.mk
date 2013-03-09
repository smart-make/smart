APP_PLATFORM := android-9
APP_ABI := x86 mips
APP_STL := gnustl_static
APP_OPTIM := debug
LIBRARY := ndk.so
SOURCES := a3.c android_main.c
LDLIBS := -llog -landroid
