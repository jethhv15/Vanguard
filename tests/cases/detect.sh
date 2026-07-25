#!/system/bin/sh
#
# Project Vanguard
# Detection Test Cases
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"

vg_detect_system >/dev/null 2>&1
vg_detect_abi >/dev/null 2>&1

vg_assert_true \
    "[ -n \"$VG_ANDROID\" ]" \
    "Android version detected"

vg_assert_true \
    "[ -n \"$VG_ABI\" ]" \
    "Device architecture detected"
