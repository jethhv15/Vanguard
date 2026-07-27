#!/system/bin/sh
#
# Project Vanguard
# Recovery Analytics Engine Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


VG_LOG="$TEST_DIR/analytics.log"


. "$CORE_DIR/recovery_analytics_engine.sh"



rm -f "$VG_LOG"



cat > "$VG_LOG" <<EOF
EVENT=RECOVERY_START
ACTION=RESTORE
RESULT=SUCCESS
---
EVENT=RECOVERY_START
ACTION=RESTORE
RESULT=SUCCESS
---
EVENT=RECOVERY_START
ACTION=ROLLBACK
RESULT=FAILED
---
EOF



vg_recovery_analytics_run \
    "$VG_LOG"



vg_assert_equal \
    "3" \
    "$VG_ANALYTICS_TOTAL" \
    "Analytics total should count events"



vg_assert_equal \
    "66" \
    "$VG_ANALYTICS_RATE" \
    "Success rate should calculate"



vg_assert_equal \
    "MEDIUM" \
    "$VG_ANALYTICS_SCORE" \
    "Score should classify result"



vg_assert_equal \
    "ROLLBACK" \
    "$VG_ANALYTICS_BEST_ACTION" \
    "Best action should detect latest action"
