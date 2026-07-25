#!/system/bin/sh
#
# Project Vanguard
# SDK Logger API
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

. "$CORE_DIR/logger.sh"

vg_log() {
    vg_logger_log "$@"
}
