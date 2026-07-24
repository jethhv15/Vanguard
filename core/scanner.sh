#!/system/bin/sh
#
# Project Vanguard
# Module Scanner
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"

#
# Constants
#

VG_MODULES_DIR="${VG_MODULES_DIR:-modules}"

#
# Public Functions
#

vg_scan_modules() {

    [ -d "$VG_MODULES_DIR" ] || return "$VG_SUCCESS"

    for module in "$VG_MODULES_DIR"/*; do

        [ -d "$module" ] || continue

        printf '%s\n' "$module"

    done

    return "$VG_SUCCESS"
}
