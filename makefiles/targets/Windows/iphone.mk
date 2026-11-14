ifeq ($(_THEOS_TARGET_LOADED),)
_THEOS_TARGET_LOADED := 1
THEOS_TARGET_NAME := iphone

_THEOS_TARGET_PLATFORM_NAME := iphoneos
_THEOS_TARGET_PLATFORM_SDK_NAME := iPhoneOS
_THEOS_TARGET_PLATFORM_FLAG_NAME := iphoneos
_THEOS_TARGET_PLATFORM_SWIFT_NAME := apple-ios

SWIFTBINPATH ?= $(THEOS)/toolchain/swift/bin
SDKBINPATH ?= $(THEOS)/toolchain/$(THEOS_PLATFORM_NAME)/$(THEOS_TARGET_NAME)/bin

# The Windows toolchain ships a single unprefixed bin directory: clang.exe,
# clang++.exe, ld.exe, lipo.exe, strip.exe, ldid.exe, ... and everything else the
# compiler drivers need to find on their own. We do *not* use Theos' prefixed
# `<triple>-ld` convention here: clang is told the target triple via -target and it
# resolves its linker from its own bin directory. `_THEOS_TARGET_SDK_BIN_PREFIX`
# therefore stays empty so darwin_tail.mk never emits a -fuse-ld= flag.
_THEOS_TARGET_SDK_BIN_PREFIX :=
_THEOS_TARGET_USE_CLANG_TARGET_FLAG := $(_THEOS_TRUE)

PREFIX := $(SDKBINPATH)/

# Every tool below exists only as `<name>.exe`. MSYS2 path translation can hide that
# for some call sites (and not for others), so spell the extension out explicitly.
_THEOS_TARGET_EXE := .exe

override TARGET_CC := $(PREFIX)clang$(_THEOS_TARGET_EXE)
override TARGET_CXX := $(PREFIX)clang++$(_THEOS_TARGET_EXE)
override TARGET_LD := $(PREFIX)clang$(_THEOS_TARGET_EXE)
override TARGET_LIPO := $(PREFIX)lipo$(_THEOS_TARGET_EXE)
override TARGET_STRIP := $(PREFIX)strip$(_THEOS_TARGET_EXE)
override TARGET_CODESIGN_ALLOCATE := $(PREFIX)codesign_allocate$(_THEOS_TARGET_EXE)
override TARGET_LIBTOOL := $(PREFIX)libtool$(_THEOS_TARGET_EXE)
override TARGET_CODESIGN := $(PREFIX)ldid$(_THEOS_TARGET_EXE)
TARGET_CODESIGN_FLAGS ?= -S
TARGET_STRIP_FLAGS ?= -x

override TARGET_DSYMUTIL :=

include $(THEOS_MAKE_PATH)/targets/_common/darwin_head.mk
include $(THEOS_MAKE_PATH)/targets/_common/iphone.mk
include $(THEOS_MAKE_PATH)/targets/_common/darwin_tail.mk

# Logos emits `__asm__(".linker_option \"-framework\", \"CydiaSubstrate\"")`,
# an assembler-level autolink hint. ld64 on macOS honours it for the .tbd-only
# stub framework we ship, but the Windows ld64 port does not, so every
# %hook goes undefined. Link the stub explicitly instead.
_THEOS_TARGET_LDFLAGS += -L"$(THEOS_VENDOR_LIBRARY_PATH)" -lsubstrate

# ldid.exe resolves the path handed to it with the MSVC CRT, which does not
# understand MSYS2's /c/... form, and Theos passes an absolute path for the
# staging copy. Sign relative to the object dir instead so ldid only ever sees
# a plain filename.
_THEOS_TARGET_CODESIGN_CD := 1

endif
