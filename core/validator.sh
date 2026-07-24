#!/system/bin/sh
#
# Project Vanguard
# Environment Validator
#

#
# Load Dependencies
#

. "$(dirname "$0")/constants.sh"
. "$(dirname "$0")/detect.sh"

#
# Public Functions
#

vg_validate_environment() {

    vg_detect_device

    if [ -z "$VG_DEVICE" ]; then
        return "$VG_ERR_UNSUPPORTED"
    fi

    if [ -z "$VG_ANDROID" ]; then
        return "$VG_ERR_UNSUPPORTED"
    fi

    return "$VG_SUCCESS"
}
