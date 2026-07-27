#!/system/bin/sh
#
# Project Vanguard
# Protection Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/protection.sh"



#
# Trusted
#

vg_protection_evaluate \
    "good_module" \
    "95"


vg_assert_equal \
    "ALLOW" \
    "$VG_PROTECTION_ACTION" \
    "Trusted module should be allowed"



#
# Warning
#

vg_protection_evaluate \
    "warning_module" \
    "70"


vg_assert_equal \
    "RESTRICT" \
    "$VG_PROTECTION_ACTION" \
    "Warning module should be restricted"



#
# Risky
#

vg_protection_evaluate \
    "bad_module" \
    "20"


vg_assert_equal \
    "QUARANTINE" \
    "$VG_PROTECTION_ACTION" \
    "Risky module should be quarantined"
