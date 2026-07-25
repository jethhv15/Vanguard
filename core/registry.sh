#!/system/bin/sh
#
# Project Vanguard
# Registry
#

#
# Runtime Storage
#

VG_LOADED_MODULES=""
VG_LOADED_MODULE_COUNT=0

#
# Public API
#

vg_registry_reset() {

    VG_LOADED_MODULES=""
    VG_LOADED_MODULE_COUNT=0

    return "$VG_SUCCESS"
}


vg_registry_add() {

    module_id="$1"
    module_path="$2"

    [ -n "$module_id" ] || return "$VG_ERR_INVALID"
    [ -n "$module_path" ] || return "$VG_ERR_INVALID"

    if vg_registry_get_path "$module_id" >/dev/null 2>&1; then
        return "$VG_ERR_GENERAL"
    fi

    entry="${module_id}|${module_path}"

    if [ -z "$VG_LOADED_MODULES" ]; then
        VG_LOADED_MODULES="$entry"
    else
        VG_LOADED_MODULES="${VG_LOADED_MODULES}
${entry}"
    fi

    VG_LOADED_MODULE_COUNT=$((VG_LOADED_MODULE_COUNT + 1))

    return "$VG_SUCCESS"
}


vg_registry_get_path() {

    module_id="$1"

    [ -n "$module_id" ] || return "$VG_ERR_INVALID"

    old_ifs="$IFS"
    IFS='
'

    for entry in $VG_LOADED_MODULES
    do
        id="$(printf '%s\n' "$entry" | cut -d'|' -f1)"
        path="$(printf '%s\n' "$entry" | cut -d'|' -f2-)"

        if [ "$id" = "$module_id" ]; then
            IFS="$old_ifs"
            printf '%s\n' "$path"
            return "$VG_SUCCESS"
        fi
    done

    IFS="$old_ifs"

    return "$VG_ERR_NOT_FOUND"
}
