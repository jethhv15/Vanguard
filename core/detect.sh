#!/system/bin/sh
#
# Project Vanguard
# Device Detection Component
#

#
# Load Dependencies
#

. "$(dirname "$0")/constants.sh"

#
# Global Variables
#

VG_DEVICE=""
VG_ANDROID=""
VG_KERNEL=""
VG_KERNELSU=""

#
# Public Functions
#

vg_detect_device() {
    VG_DEVICE="$(getprop ro.product.device)"
    VG_ANDROID="$(getprop ro.build.version.release)"
    VG_KERNEL="$(uname -r)"

    if [ -d "/data/adb/ksu" ] || [ -d "/data/adb/modules" ]; then
        VG_KERNELSU="true"
    else
        VG_KERNELSU="false"
    fi

    return "$VG_SUCCESS"
}
