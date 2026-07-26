#!/system/bin/sh
#
# Project Vanguard
# Module Validator
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Identifier
#

vg_validate_module_identifier()
{
    value="$1"

    [ -n "$value" ] || return "$VG_ERR_INVALID"

    case "$value" in
        *[!a-zA-Z0-9_-]*)
            return "$VG_ERR_INVALID"
            ;;
    esac

    return "$VG_SUCCESS"
}



#
# Entry validation
#

vg_validate_module_entry()
{
    value="$1"

    [ -n "$value" ] || return "$VG_ERR_INVALID"

    case "$value" in
        */*)
            return "$VG_ERR_INVALID"
            ;;
        *..*)
            return "$VG_ERR_INVALID"
            ;;
    esac

    return "$VG_SUCCESS"
}



#
# API validation
#

vg_validate_module_api()
{
    api="$1"

    [ -n "$api" ] || return "$VG_ERR_INVALID"


    case "$api" in
        *[!0-9]*)
            return "$VG_ERR_INVALID"
            ;;
    esac


    [ "$api" -le "$VG_API_VERSION" ] \
        || return "$VG_ERR_UNSUPPORTED"


    return "$VG_SUCCESS"
}



#
# Dependency validation
#

vg_validate_dependencies()
{
    deps="$1"


    [ -n "$deps" ] || return "$VG_SUCCESS"


    case "$deps" in

        *,)
            return "$VG_ERR_INVALID"
            ;;

        ,*)
            return "$VG_ERR_INVALID"
            ;;

        *,,*)
            return "$VG_ERR_INVALID"
            ;;

    esac


    return "$VG_SUCCESS"
}



#
# Filesystem validation
#

vg_validate_module_files()
{

    [ -z "${VG_MODULE_PATH:-}" ] \
        && return "$VG_SUCCESS"


    [ -d "$VG_MODULE_PATH" ] \
        || return "$VG_ERR_NOT_FOUND"


    entry="$VG_MODULE_PATH/$VG_MODULE_ENTRY"


    [ -f "$entry" ] \
        || return "$VG_ERR_NOT_FOUND"


    return "$VG_SUCCESS"
}



#
# Public
#

vg_validate_module()
{

    [ -n "$VG_MODULE_ID" ] || return "$VG_ERR_INVALID"
    [ -n "$VG_MODULE_NAME" ] || return "$VG_ERR_INVALID"
    [ -n "$VG_MODULE_VERSION" ] || return "$VG_ERR_INVALID"
    [ -n "$VG_MODULE_VERSION_CODE" ] || return "$VG_ERR_INVALID"
    [ -n "$VG_MODULE_AUTHOR" ] || return "$VG_ERR_INVALID"
    [ -n "$VG_MODULE_API" ] || return "$VG_ERR_INVALID"
    [ -n "$VG_MODULE_ENTRY" ] || return "$VG_ERR_INVALID"



    case "$VG_MODULE_VERSION_CODE" in
        *[!0-9]*)
            return "$VG_ERR_INVALID"
            ;;
    esac



    vg_validate_module_identifier \
        "$VG_MODULE_ID" \
        || return $?



    vg_validate_module_entry \
        "$VG_MODULE_ENTRY" \
        || return $?



    vg_validate_module_api \
        "$VG_MODULE_API" \
        || return $?



    vg_validate_dependencies \
        "$VG_MODULE_DEPENDS" \
        || return $?



    vg_validate_module_files \
        || return $?



    return "$VG_SUCCESS"

}
