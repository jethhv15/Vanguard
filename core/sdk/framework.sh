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

vg_require_api() {

    required_api="$1"

    [ -n "$required_api" ] || return "$VG_ERR_INVALID"

    [ "$VG_API_VERSION" -ge "$required_api" ]
}
