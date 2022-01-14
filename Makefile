export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.4:12.0
export SYSROOT = $(THEOS)/sdks/iOS/14/iPhoneOS14.4.sdk
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

LIBRARY_NAME = libKitten
$(LIBRARY_NAME)_FILES = Library/libKitten.m
$(LIBRARY_NAME)_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
$(LIBRARY_NAME)_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/libKitten
	$(ECHO_NOTHING)rsync -a ./Library/libKitten.h $(THEOS_STAGING_DIR)/usr/include/Kitten $(FW_RSYNC_EXCLUDES)$(ECHO_END)
	mkdir -p $(THEOS)/include/Kitten
	cp -r ./Library/libKitten.h $(THEOS)/include/Kitten
	cp $(THEOS_STAGING_DIR)/usr/lib/libKitten.dylib $(THEOS)/lib/libKitten.dylib
