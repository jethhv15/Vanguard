#!/system/bin/sh
#
# Project Vanguard
# Runtime Tests
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/runtime.sh"

vg_assert_true \
    "[ \"$VG_RUNTIME_INITIALIZED\" = \"false\" ]" \
    "Runtime should start uninitialized"

vg_runtime_init >/dev/null 2>&1

vg_assert_true \
    "[ \"$VG_RUNTIME_INITIALIZED\" = \"true\" ]" \
    "Runtime should be initialized"

vg_assert_return_code \
    0 \
    "$(vg_runtime_is_initialized; echo $?)" \
    "Runtime reports initialized"
