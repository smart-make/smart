APP_PLATFORM := android-14
APP_ABI := armeabi-v7a
APP_STL := gnustl_static
APP_OPTIM := debug
LIBRARY := ndk.so
SOURCES := a2.c android_main.c
LDLIBS := -llog -landroid
