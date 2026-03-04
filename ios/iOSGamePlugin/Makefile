THEOS_DEVICE_IP = 127.0.0.1
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Game

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GamePlugin

GamePlugin_FILES = Tweak.x GamePlugin.m
GamePlugin_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk