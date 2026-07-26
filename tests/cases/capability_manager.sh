#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/capability_manager.sh"



vg_capability_check kernel

vg_assert_return_code \
"$VG_SUCCESS" \
"$?" \
"Kernel capability exists"



vg_capability_check unknown

vg_assert_return_code \
"$VG_ERR_NOT_FOUND" \
"$?" \
"Unknown capability rejected"



list="$(vg_capability_list)"

vg_assert_true \
"[ -n \"\$list\" ]" \
"Capability list returned"
