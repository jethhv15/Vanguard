#!/system/bin/sh
#
# Project Vanguard
# Audit Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"



vg_audit_write \
"START" \
"example" \
"loaded" \
"started" \
"$VG_SUCCESS"


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Audit write completed"



log="$(vg_audit_read)"



vg_assert_true \
"[ -n \"$log\" ]" \
"Audit log contains data"
