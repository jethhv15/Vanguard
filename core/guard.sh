#!/system/bin/sh
#
# Project Vanguard
# Guard Layer
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Validate non-empty value
#

vg_guard_required()
{

    value="$1"


    [ -n "$value" ] \
        || return "$VG_ERR_INVALID"


    return "$VG_SUCCESS"

}



#
# Compatibility Alias
#
# New API compatibility
# Keeps old guard API stable
#

vg_guard_value()
{

    vg_guard_required "$1"


    return "$?"

}



#
# Validate directory
#

vg_guard_directory()
{

    dir="$1"


    [ -d "$dir" ] \
        || return "$VG_ERR_NOT_FOUND"


    return "$VG_SUCCESS"

}



#
# Validate file
#

vg_guard_file()
{

    file="$1"


    [ -f "$file" ] \
        || return "$VG_ERR_NOT_FOUND"


    return "$VG_SUCCESS"

}



#
# Validate command
#

vg_guard_command()
{

    command -v "$1" >/dev/null 2>&1 \
        || return "$VG_ERR_NOT_FOUND"


    return "$VG_SUCCESS"

}
