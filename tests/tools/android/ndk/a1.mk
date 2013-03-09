APP_PLATFORM := android-14
APP_ABI := armeabi
APP_STL := gnustl_static
APP_OPTIM := debug
LIBRARY := ndk.so
SOURCES := a1.c android_main.c
LDLIBS := -llog -landroid
