#!/system/bin/sh
#
# Project Vanguard
# Resume Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/resume.sh"



vg_resume_status >/dev/null

rc=$?

vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Resume initial state"



vg_resume_start

rc=$?

vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Resume start completed"



state="$(vg_resume_status)"



vg_assert_true \
"[ -n \"\$state\" ]" \
"Resume state returned"
