#!/system/bin/sh
#
# Project Vanguard
# Device Detection Test Cases
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_detect_device >/dev/null 2>&1; echo $?)" \
    "vg_detect_device returns success"

vg_assert_true \
    "[ -n \"$VG_DEVICE\" ]" \
    "VG_DEVICE is detected"

vg_assert_true \
    "[ -n \"$VG_ANDROID\" ]" \
    "Android version is detected"

vg_assert_true \
    "[ -n \"$VG_KERNEL\" ]" \
    "Kernel version is detected"
