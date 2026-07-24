#!/system/bin/sh
#
# Project Vanguard
# Root Manager Detection Test
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"

vg_detect_root_manager >/dev/null 2>&1

vg_assert_true \
    "[ -n \"$VG_ROOT_MANAGER\" ]" \
    "VG_ROOT_MANAGER should be initialized"
