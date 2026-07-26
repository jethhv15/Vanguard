#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/guard.sh"


vg_guard_required "hello"

vg_assert_return_code \
"$VG_SUCCESS" \
"$?" \
"Guard accepts value"



vg_guard_required ""

vg_assert_return_code \
"$VG_ERR_INVALID" \
"$?" \
"Guard rejects empty value"



vg_guard_directory "$CORE_DIR"

vg_assert_return_code \
"$VG_SUCCESS" \
"$?" \
"Guard accepts directory"



vg_guard_file "$CORE_DIR/constants.sh"

vg_assert_return_code \
"$VG_SUCCESS" \
"$?" \
"Guard accepts file"
