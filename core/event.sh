#!/system/bin/sh
#
# Project Vanguard
# Event Framework
#

VG_EVENT_REGISTRY="${VG_RUNTIME_DIR}/events"

vg_subscribe_event() {

    event="$1"
    callback="$2"

    [ -n "$event" ] || return 1
    [ -n "$callback" ] || return 1

    [ -f "$VG_EVENT_REGISTRY" ] || : > "$VG_EVENT_REGISTRY"

    printf '%s|%s\n' \
        "$event" \
        "$callback" \
        >> "$VG_EVENT_REGISTRY"

    return "$VG_SUCCESS"
}

vg_unsubscribe_event() {

    event="$1"
    callback="$2"

    [ -n "$event" ] || return 1
    [ -n "$callback" ] || return 1
    [ -f "$VG_EVENT_REGISTRY" ] || return 1

    tmp="${VG_EVENT_REGISTRY}.tmp"

    while IFS='|' read -r current current_callback
    do
        if [ "$current" = "$event" ] &&
           [ "$current_callback" = "$callback" ]
        then
            continue
        fi

        printf '%s|%s\n' \
            "$current" \
            "$current_callback"

    done < "$VG_EVENT_REGISTRY" > "$tmp"

    mv "$tmp" "$VG_EVENT_REGISTRY"

    return "$VG_SUCCESS"
}

vg_emit_event() {

    event="$1"

    [ -n "$event" ] || return 1
    [ -f "$VG_EVENT_REGISTRY" ] || return "$VG_SUCCESS"

    while IFS='|' read -r current callback
    do
        [ "$current" = "$event" ] || continue

        vg_invoke_callback "$callback"
        
    done < "$VG_EVENT_REGISTRY"

    return "$VG_SUCCESS"
}
