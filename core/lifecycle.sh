#!/system/bin/sh
#
# Project Vanguard
# Lifecycle Manager
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"

#
# Private
#

vg_lifecycle_execute() {

    suffix="$1"

    OLD_IFS=$IFS
    IFS='
'

    for module in $VG_LOADED_MODULES
    do
        "vg_${module}_${suffix}" || {
            IFS=$OLD_IFS
            return $?
        }
    done

    IFS=$OLD_IFS

    return "$VG_SUCCESS"
}

#
# Public API
#

vg_lifecycle_init() {

    vg_lifecycle_execute init
}

vg_lifecycle_start() {

    vg_lifecycle_execute start
}

vg_lifecycle_stop() {

    vg_lifecycle_execute stop
}
