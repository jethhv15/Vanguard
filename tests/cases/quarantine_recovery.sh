#!/system/bin/sh
#
# Project Vanguard
# Quarantine Recovery Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"



VG_QUARANTINE_FILE="$TEST_DIR/recovery_quarantine.db"



. "$CORE_DIR/quarantine.sh"
. "$CORE_DIR/quarantine_recovery.sh"



rm -f "$VG_QUARANTINE_FILE"



MODULE_PATH="$TEST_DIR/recovery_module"



rm -rf "$MODULE_PATH"

mkdir -p "$MODULE_PATH"



cat > "$MODULE_PATH/module.prop" <<EOF
id=recovery_test
name=Recovery Test
version=1.0
versionCode=1
author=vanguard
api=1
entry=module.sh
EOF



cat > "$MODULE_PATH/module.sh" <<EOF
vg_module_start()
{
    return 0
}
EOF



#
# Quarantine module
#

vg_quarantine_add \
    "$MODULE_PATH" \
    "test failure"



vg_quarantine_check \
    "$MODULE_PATH"



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Module should be quarantined"



#
# Recover
#

vg_quarantine_recover \
    "$MODULE_PATH"



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Recovery should complete"



#
# Check removed
#

vg_quarantine_check \
    "$MODULE_PATH"



vg_assert_equal \
    "$VG_ERR_NOT_FOUND" \
    "$?" \
    "Recovered module should leave quarantine"



vg_assert_equal \
    "recovered" \
    "$VG_RECOVERY_STATUS" \
    "Recovery status should be recovered"
