#!/system/bin/sh
#
# Project Vanguard
# Registry
#

VG_LOADED_MODULES=""
VG_LOADED_MODULE_COUNT=0

#
# Public API
#

vg_registry_reset() {
    VG_LOADED_MODULES=""
    VG_LOADED_MODULE_COUNT=0
}

vg_registry_add() {

    module_id="$1"
    module_path="$2"

    [ -n "$module_id" ] || return 1
    [ -n "$module_path" ] || return 1

    entry="${module_id}|${module_path}"

    if [ -z "$VG_LOADED_MODULES" ]; then
        VG_LOADED_MODULES="$entry"
    else
        VG_LOADED_MODULES="${VG_LOADED_MODULES}
${entry}"
    fi

    VG_LOADED_MODULE_COUNT=$((VG_LOADED_MODULE_COUNT + 1))
}

vg_registry_get_path() {

    module_id="$1"

    [ -n "$module_id" ] || return 1

    old_ifs="$IFS"
    IFS='
'

    for entry in $VG_LOADED_MODULES
    do
        id="${entry%%|*}"
        path="${entry#*|}"

        if [ "$id" = "$module_id" ]; then
            IFS="$old_ifs"
            printf '%s\n' "$path"
            return 0
        fi
    done

    IFS="$old_ifs"
    return 1
}
