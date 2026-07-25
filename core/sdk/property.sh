#!/system/bin/sh
#
# Project Vanguard
# SDK Property API
#

vg_property_get() {

    key="$1"

    case "$key" in
        id)
            printf '%s\n' "$VG_CURRENT_MODULE_ID"
            ;;
        name)
            printf '%s\n' "$VG_CURRENT_MODULE_NAME"
            ;;
        version)
            printf '%s\n' "$VG_CURRENT_MODULE_VERSION"
            ;;
        author)
            printf '%s\n' "$VG_CURRENT_MODULE_AUTHOR"
            ;;
        description)
            printf '%s\n' "$VG_CURRENT_MODULE_DESCRIPTION"
            ;;
        api)
            printf '%s\n' "$VG_CURRENT_MODULE_API"
            ;;
        path)
            printf '%s\n' "$VG_CURRENT_MODULE_PATH"
            ;;
        *)
            return 1
            ;;
    esac
}
