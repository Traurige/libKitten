export ARCHS = arm64 arm64e
export TARGET = iphone:clang:13.5:13.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS13.5.sdk/
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

LIBRARY_NAME = libKitten
$(LIBRARY_NAME)_FILES = libKitten.m
$(LIBRARY_NAME)_CFLAGS = -fobjc-arc
$(LIBRARY_NAME)_FRAMEWORKS = UIKit
ADDITIONAL_CFLAGS += -DTHEOS_LEAN_AND_MEAN

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/libKitten
	$(ECHO_NOTHING)rsync -a ./public/* $(THEOS_STAGING_DIR)/usr/include/Kitten $(FW_RSYNC_EXCLUDES)$(ECHO_END)
	mkdir -p $(THEOS)/include/Kitten
	cp -r ./public/* $(THEOS)/include/Kitten
	cp $(THEOS_STAGING_DIR)/usr/lib/libKitten.dylib $(THEOS)/lib/libKitten.dylib
