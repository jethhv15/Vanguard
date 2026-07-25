#!/system/bin/sh
#
# Project Vanguard
# Engine Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/config.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/engine.sh"


#
# Load configuration
#

vg_config_load >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Configuration loaded before engine start"


#
# Runtime boot
#

vg_runtime_boot >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Runtime boot completed before engine start"


#
# Engine start
#

vg_engine_start >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Engine start completed successfully"


vg_assert_true \
    "[ \"$VG_LOADED_MODULE_COUNT\" -gt 0 ]" \
    "Engine loaded modules successfully"
