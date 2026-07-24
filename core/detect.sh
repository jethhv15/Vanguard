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
VG_BRAND=""
VG_MODEL=""
VG_ANDROID=""
VG_SDK=""
VG_KERNEL=""
VG_KERNELSU=""
VG_SELINUX=""

#
# Public Functions
#

vg_detect_device() {
    VG_DEVICE="$(getprop ro.product.device)"
    VG_BRAND="$(getprop ro.product.brand)"
    VG_MODEL="$(getprop ro.product.model)"
    VG_ANDROID="$(getprop ro.build.version.release)"
    VG_SDK="$(getprop ro.build.version.sdk)"
    VG_KERNEL="$(uname -r)"

    if [ -d "/data/adb/ksu" ] || [ -d "/data/adb/modules" ]; then
        VG_KERNELSU="true"
    else
        VG_KERNELSU="false"
    fi

    return "$VG_SUCCESS"
}

vg_detect_selinux() {
    if command -v getenforce >/dev/null 2>&1; then
        VG_SELINUX="$(getenforce)"
        return "$VG_SUCCESS"
    fi

    VG_SELINUX="UNKNOWN"

    return "$VG_ERR_UNSUPPORTED"
}
