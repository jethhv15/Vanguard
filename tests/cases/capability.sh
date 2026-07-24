#!/system/bin/sh
#
# Project Vanguard
# Capability Detection Tests
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/capability.sh"

vg_detect_ab_slots >/dev/null 2>&1

vg_assert_true \
    "[ -n \"$VG_CAP_AB\" ]" \
    "VG_CAP_AB should always be initialized"

vg_detect_dynamic_partitions >/dev/null 2>&1

vg_assert_true \
    "[ -n \"$VG_CAP_DYNAMIC_PARTITIONS\" ]" \
    "VG_CAP_DYNAMIC_PARTITIONS should always be initialized"
