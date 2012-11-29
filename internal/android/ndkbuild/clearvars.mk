## $(ANDROID.ndk)/build/core/definitions.mk
smart~modules-LOCALS := \
    MODULE \
    MODULE_FILENAME \
    PATH \
    SRC_FILES \
    CPP_EXTENSION \
    C_INCLUDES \
    CFLAGS \
    CXXFLAGS \
    CPPFLAGS \
    STATIC_LIBRARIES \
    WHOLE_STATIC_LIBRARIES \
    SHARED_LIBRARIES \
    LDLIBS \
    ALLOW_UNDEFINED_SYMBOLS \
    ARM_MODE \
    ARM_NEON \
    DISABLE_NO_EXECUTE \
    DISABLE_RELRO \
    EXPORT_CFLAGS \
    EXPORT_CPPFLAGS \
    EXPORT_LDLIBS \
    EXPORT_C_INCLUDES \
    FILTER_ASM \
    CPP_FEATURES \
    SHORT_COMMANDS \
    \
    MAKEFILE \
    \
    LDFLAGS \
    \
    OBJECTS \
    \
    BUILT_MODULE \
    \
    OBJS_DIR \
    \
    INSTALLED \
    \
    MODULE_CLASS \

$(foreach 1,$(filter-out PATH,$(smart~modules-LOCALS)),$(eval LOCAL_$1 :=))
