#!/system/bin/sh
#
# Project Vanguard
# KernelSU Detection Component
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

VG_KERNELSU="false"

#
# Public Functions
#

vg_detect_kernelsu() {

    if [ -d "/data/adb/ksu" ] || [ -d "/data/adb/modules" ]; then
        VG_KERNELSU="true"
    else
        VG_KERNELSU="false"
    fi

    return "$VG_SUCCESS"
}
