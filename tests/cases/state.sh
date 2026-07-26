#!/system/bin/sh
#
# Project Vanguard
# State Machine Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/state.sh"


vg_state_set discovered

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "State should initialize"


vg_state_set validated

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Discovered should transition to validated"


vg_state_set loaded

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Validated should transition to loaded"


vg_state_set started

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Loaded should transition to started"


vg_state_set discovered

vg_assert_return_code \
    "$VG_ERR_INVALID" \
    "$?" \
    "Started should reject invalid rollback"
