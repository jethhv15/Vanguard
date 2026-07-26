#!/system/bin/sh
#
# Project Vanguard
# Runtime Context
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/discovery.sh"
. "$CORE_DIR/validator.sh"



#
# Runtime State
#

VG_RUNTIME_INITIALIZED="false"
VG_RUNTIME_DISCOVERED="false"
VG_RUNTIME_VALIDATED="false"



#
# Initialize Runtime
#

vg_runtime_init()
{

    VG_RUNTIME_INITIALIZED="true"

    return "$VG_SUCCESS"

}



#
# Mark Discovery Complete
#

vg_runtime_mark_discovered()
{

    VG_RUNTIME_DISCOVERED="true"

    return "$VG_SUCCESS"

}



#
# Mark Validation Complete
#

vg_runtime_mark_validated()
{

    VG_RUNTIME_VALIDATED="true"

    return "$VG_SUCCESS"

}



#
# Reset Runtime
#

vg_runtime_reset()
{

    VG_RUNTIME_INITIALIZED="false"
    VG_RUNTIME_DISCOVERED="false"
    VG_RUNTIME_VALIDATED="false"

    return "$VG_SUCCESS"

}



#
# Runtime Status
#

vg_runtime_is_initialized()
{

    [ "$VG_RUNTIME_INITIALIZED" = "true" ]

}



#
# Runtime Boot
#

vg_runtime_boot()
{

    vg_runtime_reset


    vg_runtime_init || return $?



    vg_discover

    result=$?


    if [ "$result" -ne "$VG_SUCCESS" ]; then

        vg_runtime_reset

        return "$result"

    fi



    vg_runtime_mark_discovered



    vg_validate_environment

    result=$?


    if [ "$result" -ne "$VG_SUCCESS" ]; then

        vg_runtime_reset

        return "$result"

    fi



    vg_runtime_mark_validated



    return "$VG_SUCCESS"

}
