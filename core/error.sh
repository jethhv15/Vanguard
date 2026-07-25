#!/system/bin/sh
#
# Project Vanguard
# Error Framework
#

vg_error_success() {
    return "$VG_SUCCESS"
}

vg_error_invalid_argument() {
    return "$VG_ERROR_INVALID_ARGUMENT"
}

vg_error_not_found() {
    return "$VG_ERROR_NOT_FOUND"
}

vg_error_not_supported() {
    return "$VG_ERROR_NOT_SUPPORTED"
}
