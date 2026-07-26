#!/system/bin/sh
#
# Project Vanguard
# SDK Public API
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
fi


SDK_DIR="$CORE_DIR/sdk"


#
# Load SDK services
#

. "$SDK_DIR/framework.sh"
. "$SDK_DIR/module.sh"
. "$SDK_DIR/logger.sh"
. "$SDK_DIR/property.sh"
. "$SDK_DIR/filesystem.sh"
. "$SDK_DIR/hook.sh"
. "$SDK_DIR/state.sh"



#
# SDK Information
#

VG_SDK_VERSION="1"



vg_sdk_version()
{
    printf '%s\n' "$VG_SDK_VERSION"
}



vg_sdk_loaded()
{
    return "$VG_SUCCESS"
}



#
# Module helpers
#

vg_sdk_module_ready()
{

    [ -n "$VG_CURRENT_MODULE_ID" ] || return "$VG_ERR_INVALID"

    return "$VG_SUCCESS"

}
