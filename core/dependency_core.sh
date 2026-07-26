#!/system/bin/sh
#
# Project Vanguard
# Core Dependency Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"


#
# Require Function
#

vg_require_function()
{

    function_name="$1"


    [ -n "$function_name" ] \
        || return "$VG_ERR_INVALID"



    command -v "$function_name" >/dev/null 2>&1

    if [ "$?" -ne 0 ]; then

        return "$VG_ERR_NOT_FOUND"

    fi


    return "$VG_SUCCESS"

}



#
# Require File
#

vg_require_file()
{

    file="$1"


    [ -n "$file" ] \
        || return "$VG_ERR_INVALID"



    [ -f "$file" ] \
        || return "$VG_ERR_NOT_FOUND"



    return "$VG_SUCCESS"

}



#
# Require Directory
#

vg_require_directory()
{

    dir="$1"


    [ -n "$dir" ] \
        || return "$VG_ERR_INVALID"



    [ -d "$dir" ] \
        || return "$VG_ERR_NOT_FOUND"



    return "$VG_SUCCESS"

}
