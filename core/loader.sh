#!/system/bin/sh
#
# Project Vanguard
# Logger Component
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"

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

    level="$1"
    shift

    _vg_is_valid_level "$level" || return "$VG_ERR_GENERAL"

    printf '[%s] [%s] %s\n' \
        "$(_vg_timestamp)" \
        "$level" \
        "$*"

    return "$VG_SUCCESS"
}
