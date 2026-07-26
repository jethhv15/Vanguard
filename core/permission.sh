#!/system/bin/sh
#
# Project Vanguard
# Permission Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Allowed permissions
#

VG_ALLOWED_PERMISSIONS="
root
filesystem
network
kernel
system
"



#
# Check permission
#

vg_permission_exists()
{

    target="$1"


    [ -n "$target" ] || return "$VG_ERR_INVALID"



    case "$target" in

        root)
            return "$VG_SUCCESS"
            ;;

        filesystem)
            return "$VG_SUCCESS"
            ;;

        network)
            return "$VG_SUCCESS"
            ;;

        kernel)
            return "$VG_SUCCESS"
            ;;

        system)
            return "$VG_SUCCESS"
            ;;

        *)
            return "$VG_ERR_NOT_FOUND"
            ;;

    esac

}



#
# Validate permission list
#

vg_permission_validate()
{

    list="$1"


    [ -n "$list" ] || return "$VG_SUCCESS"



    OLD_IFS="$IFS"
    IFS=','



    for permission in $list
    do

        vg_permission_exists "$permission"

        rc=$?


        if [ "$rc" -ne "$VG_SUCCESS" ]; then

            IFS="$OLD_IFS"

            return "$rc"

        fi

    done



    IFS="$OLD_IFS"


    return "$VG_SUCCESS"

}



#
# List permissions
#

vg_permission_list()
{

    cat <<EOF
root
filesystem
network
kernel
system
EOF


    return "$VG_SUCCESS"

}



#
# Check ownership
#

vg_permission_has()
{

    vg_permission_exists "$1"

}
