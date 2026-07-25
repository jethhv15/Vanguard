#!/system/bin/sh
#
# Project Vanguard
# SDK Hook API
#

vg_hook_register() {

    hook="$1"
    callback="$2"

    [ -n "$hook" ] || return 1
    [ -n "$callback" ] || return 1

    vg_register_hook "$hook" "$callback"
}
