#!/system/bin/sh
#
# Project Vanguard
# Audit Query Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"



vg_audit_write \
"TEST_EVENT" \
"example" \
"query test" \
"" \
"$VG_SUCCESS"



rc=$?

vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Audit query source data created"



data="$(vg_audit_read)"



vg_assert_true \
"[ -n \"\$data\" ]" \
"Audit read returns data"



filtered="$(vg_audit_filter TEST_EVENT)"



vg_assert_true \
"[ -n \"\$filtered\" ]" \
"Audit filter returns matching event"



last="$(vg_audit_last)"



vg_assert_true \
"[ -n \"\$last\" ]" \
"Audit last returns entry"



vg_audit_clear


rc=$?



vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Audit clear completed"
