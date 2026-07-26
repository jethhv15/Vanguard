#!/system/bin/sh
#
# Project Vanguard
# Module Validator
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/parser.sh"


#
# Internal Validation
#

vg_validate_module_identifier()
{

    value="$1"


    [ -n "$value" ] \
        || return "$VG_ERR_INVALID"


    case "$value" in

        *[!a-zA-Z0-9_-]*)
            return "$VG_ERR_INVALID"
            ;;

    esac


    return "$VG_SUCCESS"

}



vg_validate_module_entry()
{

    value="$1"


    [ -n "$value" ] \
        || return "$VG_ERR_INVALID"


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
# Public Functions
#

vg_validate_module()
{

    [ -n "$VG_MODULE_ID" ] \
        || return "$VG_ERR_INVALID"

    [ -n "$VG_MODULE_NAME" ] \
        || return "$VG_ERR_INVALID"

    [ -n "$VG_MODULE_VERSION" ] \
        || return "$VG_ERR_INVALID"


    [ -n "$VG_MODULE_VERSION_CODE" ] \
        || return "$VG_ERR_INVALID"



    case "$VG_MODULE_VERSION_CODE" in

        *[!0-9]*)
            return "$VG_ERR_INVALID"
            ;;

    esac



    [ -n "$VG_MODULE_AUTHOR" ] \
        || return "$VG_ERR_INVALID"


    [ -n "$VG_MODULE_API" ] \
        || return "$VG_ERR_INVALID"


    [ -n "$VG_MODULE_ENTRY" ] \
        || return "$VG_ERR_INVALID"



    vg_validate_module_identifier \
        "$VG_MODULE_ID" \
        || return $?



    vg_validate_module_entry \
        "$VG_MODULE_ENTRY" \
        || return $?



    vg_validate_dependencies \
        "$VG_MODULE_DEPENDS" \
        || return $?



    return "$VG_SUCCESS"

}
