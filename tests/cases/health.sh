#!/system/bin/sh
#
# Project Vanguard
# Health Monitor Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"
. "$CORE_DIR/health.sh"


#
# Mock healthy engine state
#

VG_ENGINE_STATE="$VG_ENGINE_READY"

VG_RUNTIME_INITIALIZED="true"
VG_RUNTIME_DISCOVERED="true"
VG_RUNTIME_VALIDATED="true"

VG_EXECUTOR_STATE="running"

VG_LOADED_MODULE_COUNT=1
VG_LOADED_MODULES="example|modules/example"



#
# Prepare audit
#

vg_audit_clear

vg_audit_write \
    "HEALTH_TEST" \
    "engine" \
    "" \
    "ready" \
    "$VG_SUCCESS"



#
# Run health check
#

vg_health_check

rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Health check should pass"



#
# Validate report
#

report="$(vg_health_report)"


vg_assert_true \
"[ -n \"\$report\" ]" \
"Health report generated"



echo "$report" | grep "ENGINE      : READY" >/dev/null

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Health detects ready engine"



echo "$report" | grep "RUNTIME     : VALID" >/dev/null

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Health detects valid runtime"



echo "$report" | grep "EXECUTOR    : RUNNING" >/dev/null

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Health detects running executor"



echo "$report" | grep "AUDIT       : OK" >/dev/null

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Health validates audit chain"



echo "$report" | grep "HEALTH      : PASS" >/dev/null

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Health status is healthy"
