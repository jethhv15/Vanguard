#!/system/bin/sh
#
# Project Vanguard
# ABI Detection Test
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_detect_abi >/dev/null 2>&1; echo $?)" \
    "vg_detect_abi returns success"

vg_assert_true \
    "[ -n \"$VG_ABI\" ]" \
    "VG_ABI should not be empty"
