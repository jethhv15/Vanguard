#!/system/bin/sh
#
# Project Vanguard
# Hook Framework
#

VG_HOOKS=""

vg_register_hook() {

    hook="$1"
    callback="$2"

    [ -n "$hook" ] || return 1
    [ -n "$callback" ] || return 1

    VG_HOOKS="${VG_HOOKS}${hook}|${callback}
"

    return 0
}

vg_dispatch_hook() {

    hook="$1"

    [ -n "$hook" ] || return 1

    printf '%s' "$VG_HOOKS" | while IFS='|' read -r current callback
    do
        [ "$current" = "$hook" ] || continue

        command -v "$callback" >/dev/null 2>&1 || continue

        "$callback"
    done
}
