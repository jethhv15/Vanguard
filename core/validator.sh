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

    vg_detect_device || return "$VG_ERR_INTERNAL"

    [ -n "$VG_DEVICE" ] || return "$VG_ERR_UNSUPPORTED"
    [ -n "$VG_BRAND" ] || return "$VG_ERR_UNSUPPORTED"
    [ -n "$VG_MODEL" ] || return "$VG_ERR_UNSUPPORTED"
    [ -n "$VG_ANDROID" ] || return "$VG_ERR_UNSUPPORTED"
    [ -n "$VG_SDK" ] || return "$VG_ERR_UNSUPPORTED"
    [ -n "$VG_KERNEL" ] || return "$VG_ERR_UNSUPPORTED"

    return "$VG_SUCCESS"
}
