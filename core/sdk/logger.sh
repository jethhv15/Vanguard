#!/system/bin/sh
#
# Project Vanguard
# SDK Logger API
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
fi

. "$CORE_DIR/logger.sh"

vg_log() {
    vg_logger_log "$@"
}
