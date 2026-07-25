#!/system/bin/sh
#
# Project Vanguard
# Discovery Manager
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"
. "$CORE_DIR/capability.sh"

#
# Public Functions
#

vg_discover() {

    vg_detect_device
    vg_detect_selinux
    vg_detect_abi
    vg_detect_root_manager

    vg_detect_ab_slots
    vg_detect_dynamic_partitions

    return "$VG_SUCCESS"
}
