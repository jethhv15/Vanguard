#!/system/bin/sh
#
# Project Vanguard
# Configuration Test Cases
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/config.sh"

VG_CONFIG_FILE="$CONFIG_DIR/default.conf"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_config_load >/dev/null 2>&1; echo $?)" \
    "vg_config_load loads valid configuration"

vg_assert_equal \
    "INFO" \
    "$(vg_config_get VG_LOG_LEVEL)" \
    "VG_LOG_LEVEL matches default configuration"
