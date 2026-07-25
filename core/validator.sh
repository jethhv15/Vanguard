#!/system/bin/sh
#
# Project Vanguard
# Validation Component
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"

#
# Public Functions
#

vg_validate_environment() {

    vg_detect_system || return $?
    vg_detect_abi || return $?

    return "$VG_SUCCESS"
}
