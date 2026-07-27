#!/system/bin/sh
#
# Project Vanguard
# Recovery Telemetry Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


VG_TELEMETRY_FILE="$TEST_DIR/telemetry.log"


. "$CORE_DIR/recovery_telemetry.sh"



rm -f "$VG_TELEMETRY_FILE"



#
# Record
#

vg_telemetry_record \
    "RECOVERY_START" \
    "RESTORE" \
    "EXECUTING" \
    "RUNNING"



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Telemetry record should succeed"



#
# Validate state
#

vg_assert_equal \
    "RECOVERY_START" \
    "$VG_TELEMETRY_EVENT" \
    "Event should store"



vg_assert_equal \
    "RESTORE" \
    "$VG_TELEMETRY_ACTION" \
    "Action should store"



#
# Count
#

count=$(vg_telemetry_count "RECOVERY_START")



vg_assert_equal \
    "1" \
    "$count" \
    "Event count should match"
