LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := su

LOCAL_SRC_FILES := \
	su.c \
	daemon.c \
	activity.c \
	db.c \
	utils.c \
	../sqlite/dist/sqlite3.c

LOCAL_C_INCLUDES := \
	external/sqlite/dist

LOCAL_STATIC_LIBRARIES := \
	libc \
	libcutils

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng debug
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_CFLAGS := -DSQLITE_OMIT_LOAD_EXTENSION
LOCAL_CFLAGS += -DSUPERUSER_EMBEDDED
LOCAL_CFLAGS += -DREQUESTOR=\"com.evervolv.toolbox\"
LOCAL_CFLAGS += -DREQUESTOR_PREFIX=\"com.evervolv.toolbox.superuser\"

include $(BUILD_EXECUTABLE)

SYMLINKS := $(addprefix $(TARGET_OUT)/bin/,su)
$(SYMLINKS): $(LOCAL_MODULE)
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	@echo "Symlink: $@ -> /system/xbin/su"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf ../xbin/su $@

ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)

# We need this so that the installed files could be picked up based on the
# local module name
ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
    $(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(SYMLINKS)
