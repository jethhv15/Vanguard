#!/system/bin/sh
#
# Project Vanguard
# Device Detection Component
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

# Device
VG_DEVICE=""
VG_BRAND=""
VG_MODEL=""

# System
VG_ANDROID=""
VG_SDK=""
VG_KERNEL=""
VG_SELINUX=""

# Hardware
VG_ABI=""

# Environment
VG_KERNELSU=""
VG_ROOT_MANAGER=""

#
# Public Functions
#

vg_detect_device() {
    VG_DEVICE="$(getprop ro.product.device)"
    VG_BRAND="$(getprop ro.product.brand)"
    VG_MODEL="$(getprop ro.product.model)"

    return "$VG_SUCCESS"
}

vg_detect_system() {
    VG_ANDROID="$(getprop ro.build.version.release)"
    VG_SDK="$(getprop ro.build.version.sdk)"
    VG_KERNEL="$(uname -r)"
    VG_SELINUX="$(getenforce 2>/dev/null)"

    return "$VG_SUCCESS"
}

vg_detect_abi() {
    VG_ABI="$(getprop ro.product.cpu.abi)"

    [ -n "$VG_ABI" ] || return "$VG_ERR_GENERAL"

    return "$VG_SUCCESS"
}

vg_detect_root_manager() {

    if command -v magisk >/dev/null 2>&1; then
        VG_ROOT_MANAGER="Magisk"
    elif [ -d "/data/adb/ksu" ]; then
        VG_ROOT_MANAGER="KernelSU"
    else
        VG_ROOT_MANAGER="None"
    fi

    return "$VG_SUCCESS"
}
