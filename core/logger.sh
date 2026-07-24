#!/system/bin/sh
#
# Project Vanguard
# Logger Component
#

#
# Load Dependencies
#

. "$(dirname "$0")/constants.sh"

#
# Private Functions
#

_vg_is_valid_level() {
    case "$1" in
        "$VG_LOG_INFO"|"$VG_LOG_WARN"|"$VG_LOG_ERROR"|"$VG_LOG_DEBUG")
            return "$VG_SUCCESS"
            ;;
        *)
            return "$VG_ERR_GENERAL"
            ;;
    esac
}

#
# Public Functions
#

vg_log() {
    local level="$1"
    shift

    _vg_is_valid_level "$level" || return "$VG_ERR_GENERAL"

    if [ $# -eq 0 ]; then
        return "$VG_ERR_GENERAL"
    fi

    printf '[%s] %s\n' "$level" "$*"

    return "$VG_SUCCESS"
}
