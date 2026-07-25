#!/system/bin/sh
#
# Project Vanguard
# Utility Component
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"

#
# Public Functions
#

vg_file_exists() {
    [ -f "$1" ]
}

vg_dir_exists() {
    [ -d "$1" ]
}

vg_command_exists() {
    command -v "$1" >/dev/null 2>&1
}
