#!/system/bin/sh
#
# Project Vanguard
# Capability Detection Component
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"

#
# Global Variables
#

VG_CAP_DYNAMIC_PARTITIONS="false"
VG_CAP_AB="false"

#
# Public Functions
#

vg_detect_dynamic_partitions() {

    if [ -d "/dev/block/by-name" ] && \
       [ -e "/dev/block/by-name/super" ]; then
        VG_CAP_DYNAMIC_PARTITIONS="true"
        return "$VG_SUCCESS"
    fi

    return "$VG_ERR_UNSUPPORTED"
}

vg_detect_ab_slots() {

    slot_count="$(getprop ro.boot.slot_suffix)"

    if [ -n "$slot_count" ]; then
        VG_CAP_AB="true"
        return "$VG_SUCCESS"
    fi

    return "$VG_ERR_UNSUPPORTED"
}
