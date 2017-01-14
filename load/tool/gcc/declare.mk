# G_GNUC_WARN_UNUSED_RESULT
# -Werror=format  -->  __attribute__((__sentinel__)) (e.g. G_GNUC_NULL_TERMINATED)
GCC_Werrors := $(addprefix -Werror=,\
  declaration-after-statement \
  format \
  format-extra-args \
  implicit-function-declaration \
  nested-externs \
  pointer-sign \
  return-type \
  switch \
  uninitialized \
  unused-function \
  unused-variable \
  unused-result \
  int-to-pointer-cast \
  enum-compare \
  declaration-after-statement \
  )

CC := gcc
CFLAGS := $(GCC_Werrors)
CXXFLAGS := $(GCC_Werrors)
ARFLAGS := cru
LDFLAGS :=
LIBADD :=
LOADLIBS :=

ifeq ($(shell uname),Linux)

EXEEXT :=

else # uname == Linux
LOADLIBS += \
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

EXEEXT := .exe
endif # uname != Linux
