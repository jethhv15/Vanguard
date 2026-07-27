#!/system/bin/sh
#
# Project Vanguard
# Scanner
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Runtime
#

VG_SCANNED_MODULES=""


#
# Scan modules
#

vg_scan_modules()
{

    VG_SCANNED_MODULES=""


    [ -d "$VG_MODULES_DIR" ] \
        || return "$VG_ERR_NOT_FOUND"



    for module in "$VG_MODULES_DIR"/*
    do

        #
        # Only directories
        #

        [ -d "$module" ] || continue



        #
        # Module manifest required
        #

        manifest="$module/module.prop"


        [ -f "$manifest" ] || continue



        #
        # Read module type
        #

        module_type=""

        while IFS='=' read -r key value
        do

            case "$key" in

                type)
                    module_type="$value"
                    ;;

            esac

        done < "$manifest"



        #
        # Skip non-runtime modules
        #

        case "$module_type" in

            template|library|disabled)
                continue
                ;;

        esac



        #
        # Add runtime module
        #

        if [ -z "$VG_SCANNED_MODULES" ]; then

            VG_SCANNED_MODULES="$module"

        else

            VG_SCANNED_MODULES="${VG_SCANNED_MODULES}
$module"

        fi


    done



    return "$VG_SUCCESS"

}
