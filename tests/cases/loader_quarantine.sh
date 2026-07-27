#!/system/bin/sh
#
# Project Vanguard
# Loader Quarantine Enforcement Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"



#
# Set quarantine database
# Before sourcing quarantine and loader
#

VG_QUARANTINE_FILE="$TEST_DIR/loader_quarantine.db"



. "$CORE_DIR/quarantine.sh"
. "$CORE_DIR/loader.sh"



#
# Cleanup
#

rm -f "$VG_QUARANTINE_FILE"



MODULE_PATH="$TEST_DIR/quarantine_module"



rm -rf "$MODULE_PATH"

mkdir -p "$MODULE_PATH"



#
# Valid Vanguard module manifest
#

cat > "$MODULE_PATH/module.prop" <<EOF
id=quarantine_test
name=Quarantine Test
version=1.0
versionCode=1
author=vanguard
api=1
entry=module.sh
EOF



#
# Module implementation
#

cat > "$MODULE_PATH/module.sh" <<EOF
vg_module_start()
{
    return 0
}


vg_module_stop()
{
    return 0
}
EOF



#
# Add quarantine
#

vg_quarantine_add \
    "$MODULE_PATH" \
    "low reliability"



#
# Loader must reject quarantined module
#

vg_load_module \
    "$MODULE_PATH"


rc=$?



vg_assert_equal \
    "$VG_ERR_INVALID" \
    "$rc" \
    "Loader should reject quarantined module"



#
# Remove quarantine
#

vg_quarantine_remove \
    "$MODULE_PATH"



#
# Verify quarantine removed
#

vg_quarantine_check \
    "$MODULE_PATH"


qrc=$?



vg_assert_equal \
    "$VG_ERR_NOT_FOUND" \
    "$qrc" \
    "Module should be removed from quarantine"



#
# Loader must allow recovered module
#

vg_load_module \
    "$MODULE_PATH"


rc=$?



vg_assert_equal \
    "$VG_SUCCESS" \
    "$rc" \
    "Loader should allow recovered module"
