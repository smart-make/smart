TOOLPREFIX = i686-w64-mingw32-

# G_GNUC_WARN_UNUSED_RESULT
# -Werror=format  -->  __attribute__((__sentinel__)) (e.g. G_GNUC_NULL_TERMINATED)
GCC_Werrors := \
  -Werror=declaration-after-statement \
  -Werror=format \
  -Werror=format-extra-args \
  -Werror=implicit-function-declaration \
  -Werror=nested-externs \
  -Werror=pointer-sign \
  -Werror=return-type \
  -Werror=switch \
  -Werror=uninitialized \
  -Werror=unused-function \
  -Werror=unused-variable \
  -Werror=unused-result \

CFLAGS := $(GCC_Werrors) -Werror=declaration-after-statement
CXXFLAGS := $(GCC_Werrors)
INCLUDES :=
DEFINES :=
ARFLAGS := cru
LDFLAGS :=
LIBADD :=
LOADLIBS := \
  -lkernel32\
  -luser32\
  -lgdi32\
  -lcomdlg32\
  -lwinspool\
  -lwinmm\
  -lshell32\
  -lcomctl32\
  -lole32\
  -loleaut32\
  -luuid\
  -lrpcrt4\
  -ladvapi32\
  -lwsock32\
  -lodbc32\
  -lws2_32\
  -lnetapi32\
  -lmpr\

REQUIRES :=
