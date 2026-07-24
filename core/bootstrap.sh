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

    if ! vg_config_load; then
        vg_error "Failed to load configuration."
        return "$VG_ERR_CONFIG"
    fi

    if ! vg_validate_environment; then
        vg_error "Environment validation failed."
        return "$VG_ERR_UNSUPPORTED"
    fi

    vg_info "Environment validated."
    vg_info "Bootstrap completed successfully."

    return "$VG_SUCCESS"
}
