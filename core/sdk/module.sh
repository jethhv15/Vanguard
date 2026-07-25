#!/system/bin/sh
#
# Project Vanguard
# SDK Module API
#

vg_module_id() {
    printf '%s\n' "$VG_CURRENT_MODULE_ID"
}

vg_module_name() {
    printf '%s\n' "$VG_CURRENT_MODULE_NAME"
}

vg_module_version() {
    printf '%s\n' "$VG_CURRENT_MODULE_VERSION"
}

vg_module_author() {
    printf '%s\n' "$VG_CURRENT_MODULE_AUTHOR"
}

vg_module_description() {
    printf '%s\n' "$VG_CURRENT_MODULE_DESCRIPTION"
}

vg_module_api() {
    printf '%s\n' "$VG_CURRENT_MODULE_API"
}
