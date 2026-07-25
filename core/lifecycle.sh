#!/system/bin/sh
#
# Project Vanguard
# Lifecycle Manager
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/dispatcher.sh"

#
# Internal
#

vg_lifecycle_execute() {

    action="$1"

    [ -n "$action" ] || return "$VG_ERR_INVALID"

    old_ifs="$IFS"
    IFS='
'

    for entry in $VG_LOADED_MODULES
    do
        module_id="${entry%%|*}"

        vg_dispatch_module "$module_id" "$action" || {
            IFS="$old_ifs"
            return $?
        }
    done

    IFS="$old_ifs"

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
