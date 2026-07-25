#!/system/bin/sh
#
# Project Vanguard
# Service Framework
#

VG_SERVICE_REGISTRY="${VG_RUNTIME_DIR}/services"

vg_register_service() {

    name="$1"
    implementation="$2"

    [ -n "$name" ] || return 1
    [ -n "$implementation" ] || return 1

    [ -f "$VG_SERVICE_REGISTRY" ] || : > "$VG_SERVICE_REGISTRY"

    printf '%s|%s\n' \
        "$name" \
        "$implementation" \
        >> "$VG_SERVICE_REGISTRY"

    return "$VG_SUCCESS"
}

vg_resolve_service() {

    name="$1"

    [ -n "$name" ] || return 1
    [ -f "$VG_SERVICE_REGISTRY" ] || return 1

    while IFS='|' read -r current implementation
    do
        [ "$current" = "$name" ] || continue

        printf '%s\n' "$implementation"

        return "$VG_SUCCESS"
    done < "$VG_SERVICE_REGISTRY"

    return "$VG_ERROR_NOT_FOUND"
}

vg_unregister_service() {

    name="$1"

    [ -n "$name" ] || return 1
    [ -f "$VG_SERVICE_REGISTRY" ] || return 1

    tmp="${VG_SERVICE_REGISTRY}.tmp"

    while IFS='|' read -r current implementation
    do
        [ "$current" = "$name" ] && continue

        printf '%s|%s\n' \
            "$current" \
            "$implementation"

    done < "$VG_SERVICE_REGISTRY" > "$tmp"

    mv "$tmp" "$VG_SERVICE_REGISTRY"

    return "$VG_SUCCESS"
}
