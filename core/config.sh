#!/system/bin/sh
#
# Project Vanguard
# Configuration Component
#

#
# Load Dependencies
#

. "$(dirname "$0")/constants.sh"

#
# Global Variables
#

VG_CONFIG_FILE="$(dirname "$0")/../config/default.conf"

#
# Public Functions
#

vg_config_load() {

    if [ ! -f "$VG_CONFIG_FILE" ]; then
        return "$VG_ERR_CONFIG"
    fi

    . "$VG_CONFIG_FILE"

    return "$VG_SUCCESS"
}

vg_config_get() {
    eval "printf '%s' \"\${$1}\""
}

vg_config_set() {
    eval "$1=\"\$2\""
    return "$VG_SUCCESS"
}
vg_config_set() {
    eval "$1=\"$2\""

    return "$VG_SUCCESS"
}
