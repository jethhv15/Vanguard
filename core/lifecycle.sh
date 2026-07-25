#!/system/bin/sh
#
# Project Vanguard
# Lifecycle Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

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

    started_modules=""

    for entry in $VG_LOADED_MODULES
    do
        module_id="${entry%%|*}"

        if ! vg_dispatch_module "$module_id" "$action"; then
            result=$?

            if [ "$action" = "start" ]; then
                rollback_ifs="$IFS"
                IFS='
'

                for started in $started_modules
                do
                    vg_dispatch_module "$started" stop >/dev/null 2>&1
                done

                IFS="$rollback_ifs"
            fi

            IFS="$old_ifs"
            return "$result"
        fi

        if [ "$action" = "start" ]; then
            if [ -z "$started_modules" ]; then
                started_modules="$module_id"
            else
                started_modules="${started_modules}
${module_id}"
            fi
        fi
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
