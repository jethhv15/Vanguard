#!/system/bin/sh
#
# Project Vanguard
# Reliability Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/reliability.sh"



TEST_HISTORY="$TEST_DIR/reliability_history.log"



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



vg_reliability_calculate \
    "example" \
    "$TEST_HISTORY"



vg_assert_equal \
    "50" \
    "$(vg_reliability_score)" \
    "Reliability score"



vg_assert_equal \
    "warning" \
    "$(vg_reliability_status)" \
    "Reliability status"
