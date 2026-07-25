#!/system/bin/sh
#
# Project Vanguard
# Detection Test Cases
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"

vg_detect_environment >/dev/null 2>&1

vg_assert_true \
    "[ -n \"$VG_ANDROID_VERSION\" ]" \
    "Android version detected"

vg_assert_true \
    "[ -n \"$VG_DEVICE_ARCH\" ]" \
    "Device architecture detected"
