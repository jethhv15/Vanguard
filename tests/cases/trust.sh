#!/system/bin/sh
#
# Project Vanguard
# Trust Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/trust.sh"



vg_trust_clear



vg_trust_add example


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Trusted module added"



state="$(vg_trust_get example)"


vg_assert_equal \
"trusted" \
"$state" \
"Trusted state returned"



vg_trust_check example


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Trusted module accepted"



vg_trust_block malware


vg_trust_check malware


rc=$?


vg_assert_return_code \
"$VG_ERR_PERMISSION" \
"$rc" \
"Blocked module rejected"



list="$(vg_trust_list)"


vg_assert_true \
"[ -n \"\$list\" ]" \
"Trust list returned"
