#!/system/bin/sh
#
# Project Vanguard
# Hook Framework
#

VG_HOOK_REGISTRY="${VG_RUNTIME_DIR}/hooks"

vg_register_hook() {

    hook="$1"
    callback="$2"

    [ -n "$hook" ] || return 1
    [ -n "$callback" ] || return 1

    printf '%s|%s\n' "$hook" "$callback" >> "$VG_HOOK_REGISTRY"
}

vg_dispatch_hook() {

    hook="$1"

    [ -n "$hook" ] || return 1
    [ -f "$VG_HOOK_REGISTRY" ] || return 0

    while IFS='|' read -r current callback
    do
        [ "$current" = "$hook" ] || continue

        vg_invoke_callback "$callback"
        
    done < "$VG_HOOK_REGISTRY"
}
