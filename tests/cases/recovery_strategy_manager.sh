#!/system/bin/sh
#
# Project Vanguard
# Recovery Strategy Manager Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


VG_STRATEGY_FILE="$TEST_DIR/strategies.db"


. "$CORE_DIR/recovery_strategy_manager.sh"



rm -f "$VG_STRATEGY_FILE"



#
# Register
#

vg_strategy_register \
    "RESTORE" \
    95


vg_strategy_register \
    "ROLLBACK" \
    80


vg_strategy_register \
    "RETRY" \
    50



#
# Select
#

vg_strategy_select_best



vg_assert_equal \
    "RESTORE" \
    "$VG_SELECTED_STRATEGY" \
    "Best strategy should be selected"



vg_assert_equal \
    "95" \
    "$VG_STRATEGY_SCORE" \
    "Highest score should win"
