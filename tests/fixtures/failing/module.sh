#!/system/bin/sh
#
# Project Vanguard
# Failing Test Module
#

vg_failing_init() {

    return "$VG_SUCCESS"
}

vg_failing_start() {

    return "$VG_ERR_INTERNAL"
}

vg_failing_stop() {

    return "$VG_SUCCESS"
}
