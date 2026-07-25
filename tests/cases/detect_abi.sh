#!/system/bin/sh
#
# Project Vanguard
# ABI Detection Test Cases
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"

vg_detect_abi >/dev/null 2>&1

vg_assert_true \
    "[ -n \"$VG_DEVICE_ABI\" ]" \
    "ABI detected successfully"
