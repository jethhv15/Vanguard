#!/system/bin/sh
#
# Project Vanguard
# SDK Framework API
#

vg_framework_version() {
    printf '%s\n' "$VG_VERSION"
}

vg_framework_api() {
    printf '%s\n' "$VG_API_VERSION"
}
