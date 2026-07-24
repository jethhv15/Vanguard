#!/system/bin/sh
#
# Project Vanguard
# Bootstrap
#

#
# Load Components
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/logger.sh"
. "$CORE_DIR/config.sh"
. "$CORE_DIR/detect.sh"
. "$CORE_DIR/validator.sh"

#
# Public Functions
#

vg_bootstrap() {

    vg_info "Initializing Project Vanguard..."

    vg_config_load || return $?

    vg_validate_environment || return $?

    vg_info "Environment validated."

    return "$VG_SUCCESS"
}

#
# Entry Point
#

vg_bootstrap
