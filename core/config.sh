#!/system/bin/sh
#
# Project Vanguard
# Configuration Component
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"

#
# Global Variables
#

if [ -z "${CONFIG_DIR:-}" ]; then
    CONFIG_DIR="$CORE_DIR/../config"
fi

VG_CONFIG_FILE="$CONFIG_DIR/default.conf"

if [ -z "${VG_MODULES_DIR:-}" ]; then
    VG_MODULES_DIR="$CORE_DIR/../modules"
fi

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
