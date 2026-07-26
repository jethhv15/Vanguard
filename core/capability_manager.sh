#!/system/bin/sh
#
# Project Vanguard
# Capability Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# Registered capabilities
#

VG_AVAILABLE_CAPABILITIES="
root
magisk
kernel
selinux
dynamic_partitions
filesystem
network
"



#
# Internal
#

vg_capability_exists()
{

    target="$1"


    [ -n "$target" ] || return "$VG_ERR_INVALID"



    for cap in $VG_AVAILABLE_CAPABILITIES
    do

        [ "$cap" = "$target" ] && return "$VG_SUCCESS"

    done



    return "$VG_ERR_NOT_FOUND"

}



#
# Public API
#

vg_capability_check()
{

    capability="$1"


    vg_capability_exists "$capability"

}



vg_capability_list()
{

    printf '%s\n' \
        "$VG_AVAILABLE_CAPABILITIES"


    return "$VG_SUCCESS"

}
