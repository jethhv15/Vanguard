#!/system/bin/sh
#
# Project Vanguard
# Module Manifest Parser
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Runtime Variables
#

VG_MODULE_ID=""
VG_MODULE_NAME=""
VG_MODULE_VERSION=""
VG_MODULE_VERSION_CODE=""
VG_MODULE_AUTHOR=""
VG_MODULE_DESCRIPTION=""
VG_MODULE_API=""
VG_MODULE_ENTRY=""
VG_MODULE_DEPENDS=""


#
# Public Functions
#

vg_parse_manifest() {

    manifest="$1"

    [ -f "$manifest" ] || return "$VG_ERR_NOT_FOUND"


    #
    # Reset runtime context
    #

    VG_MODULE_ID=""
    VG_MODULE_NAME=""
    VG_MODULE_VERSION=""
    VG_MODULE_VERSION_CODE=""
    VG_MODULE_AUTHOR=""
    VG_MODULE_DESCRIPTION=""
    VG_MODULE_API=""
    VG_MODULE_ENTRY=""
    VG_MODULE_DEPENDS=""


    while IFS='=' read -r key value
    do

        [ -n "$key" ] || continue


        case "$key" in
            \#*)
                continue
                ;;
        esac


        case "$key" in

            id)
                VG_MODULE_ID="$value"
                ;;

            name)
                VG_MODULE_NAME="$value"
                ;;

            version)
                VG_MODULE_VERSION="$value"
                ;;

            versionCode)
                VG_MODULE_VERSION_CODE="$value"
                ;;

            author)
                VG_MODULE_AUTHOR="$value"
                ;;

            description)
                VG_MODULE_DESCRIPTION="$value"
                ;;

            api)
                VG_MODULE_API="$value"
                ;;

            entry)
                VG_MODULE_ENTRY="$value"
                ;;

            depends)
                VG_MODULE_DEPENDS="$value"
                ;;

        esac


    done < "$manifest"


    return "$VG_SUCCESS"
}
