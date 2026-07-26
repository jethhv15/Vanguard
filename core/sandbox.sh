#!/system/bin/sh
#
# Project Vanguard
# Module Sandbox
#


if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



VG_SANDBOX_STATE="disabled"



vg_sandbox_enable()
{

    VG_SANDBOX_STATE="enabled"

    return "$VG_SUCCESS"

}



vg_sandbox_disable()
{

    VG_SANDBOX_STATE="disabled"

    return "$VG_SUCCESS"

}



vg_sandbox_status()
{

    printf '%s\n' \
        "$VG_SANDBOX_STATE"


    return "$VG_SUCCESS"

}
