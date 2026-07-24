#!/system/bin/sh
#
# Project Vanguard
# Engine Tests
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/engine.sh"

vg_runtime_init >/dev/null 2>&1

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_engine_start >/dev/null 2>&1; echo $?)" \
    "Engine should start after runtime initialization"
