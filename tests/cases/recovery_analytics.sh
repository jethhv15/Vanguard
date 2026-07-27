#!/system/bin/sh
#
# Project Vanguard
# Recovery Analytics Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_analytics.sh"



TEST_HISTORY="$TEST_DIR/analytics_history.log"



cat > "$TEST_HISTORY" <<EOF
TIME=20260727100000
MODULE=example
ACTION=RETRY_MODULE
LEVEL=safe
RESULT=SUCCESS
REASON=test
ATTEMPT=1
---
TIME=20260727110000
MODULE=example
ACTION=RESTORE_SNAPSHOT
LEVEL=critical
RESULT=FAILED
REASON=test
ATTEMPT=2
---
EOF



vg_recovery_analytics_scan \
    "$TEST_HISTORY"



vg_assert_equal \
    "2" \
    "$(vg_recovery_analytics_total)" \
    "Analytics total count"



vg_assert_equal \
    "1" \
    "$(vg_recovery_analytics_success)" \
    "Analytics success count"



vg_assert_equal \
    "1" \
    "$(vg_recovery_analytics_failed)" \
    "Analytics failed count"
