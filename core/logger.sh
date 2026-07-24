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

_vg_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
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

    printf '%s [%s] %s\n' "$(_vg_timestamp)" "$level" "$*"

    return "$VG_SUCCESS"
}

vg_info() {
    vg_log "$VG_LOG_INFO" "$@"
}

vg_warn() {
    vg_log "$VG_LOG_WARN" "$@"
}

vg_error() {
    vg_log "$VG_LOG_ERROR" "$@"
}

vg_debug() {
    vg_log "$VG_LOG_DEBUG" "$@"
}
    if [ $# -eq 0 ]; then
        return "$VG_ERR_GENERAL"
    fi

    printf '[%s] %s\n' "$level" "$*"

    return "$VG_SUCCESS"
}
