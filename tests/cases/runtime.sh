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

#
# Runtime initialization
#

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

#
# Runtime state management
#

vg_runtime_mark_discovered >/dev/null 2>&1

vg_assert_true \
    "[ \"$VG_RUNTIME_DISCOVERED\" = \"true\" ]" \
    "Runtime should be marked discovered"

vg_runtime_mark_validated >/dev/null 2>&1

vg_assert_true \
    "[ \"$VG_RUNTIME_VALIDATED\" = \"true\" ]" \
    "Runtime should be marked validated"

vg_runtime_reset >/dev/null 2>&1

vg_assert_true \
    "[ \"$VG_RUNTIME_INITIALIZED\" = \"false\" ]" \
    "Runtime should reset initialization state"

vg_assert_true \
    "[ \"$VG_RUNTIME_DISCOVERED\" = \"false\" ]" \
    "Runtime should reset discovery state"

vg_assert_true \
    "[ \"$VG_RUNTIME_VALIDATED\" = \"false\" ]" \
    "Runtime should reset validation state"

#
# Runtime boot sequence
#

vg_runtime_boot >/dev/null 2>&1

vg_assert_true \
    "[ \"$VG_RUNTIME_INITIALIZED\" = \"true\" ]" \
    "Runtime boot should initialize runtime"

vg_assert_true \
    "[ \"$VG_RUNTIME_DISCOVERED\" = \"true\" ]" \
    "Runtime boot should complete discovery"

vg_assert_true \
    "[ \"$VG_RUNTIME_VALIDATED\" = \"true\" ]" \
    "Runtime boot should complete validation"
