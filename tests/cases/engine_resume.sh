#!/system/bin/sh
#
# Project Vanguard
# Engine Resume Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/engine.sh"
. "$CORE_DIR/audit.sh"



vg_runtime_init


vg_engine_start

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Engine resume boot completed"



log="$(vg_audit_filter ENGINE_READY)"



vg_assert_true \
"[ -n \"\$log\" ]" \
"Engine ready audit generated"
