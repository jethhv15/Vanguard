#!/system/bin/sh
#
# Project Vanguard
# Module Loader
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/module_validator.sh"

#
# Public Functions
#

vg_load_module() {

    module_path="$1"

    manifest="$module_path/module.prop"

    vg_parse_manifest "$manifest" || return $?

    vg_validate_module || return $?

    return "$VG_SUCCESS"
}
