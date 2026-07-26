#!/system/bin/sh
#
# Project Vanguard
# Permission Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/permission.sh"



vg_permission_validate \
"root,filesystem"

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Valid permissions accepted"



vg_permission_validate \
"root,unknown"

rc=$?


vg_assert_return_code \
"$VG_ERR_NOT_FOUND" \
"$rc" \
"Invalid permission rejected"



list="$(vg_permission_list)"

vg_assert_true \
"[ -n \"\$list\" ]" \
"Permission list returned"



vg_test_summary
