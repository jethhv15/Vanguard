#!/system/bin/sh
#
# Project Vanguard
# Runtime Persistence Layer
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Storage
#

if [ -z "${VG_RUNTIME_DIR:-}" ]; then

    if [ -d "/data/adb" ] && [ -w "/data/adb" ]; then
        VG_RUNTIME_DIR="/data/adb/vanguard/runtime"
    else
        VG_RUNTIME_DIR="$CORE_DIR/../runtime"
    fi

fi


VG_PERSIST_FILE="$VG_RUNTIME_DIR/runtime.state"
VG_PERSIST_TMP="${VG_PERSIST_FILE}.tmp"



#
# Prepare
#

vg_persistence_prepare()
{

    [ -d "$VG_RUNTIME_DIR" ] || mkdir -p "$VG_RUNTIME_DIR" 2>/dev/null


    [ -d "$VG_RUNTIME_DIR" ] \
        || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



#
# Validate state file
#

vg_persistence_validate()
{

    [ -f "$VG_PERSIST_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"


    grep "^timestamp=" "$VG_PERSIST_FILE" >/dev/null 2>&1 \
        || return "$VG_ERR_INVALID"


    grep "^runtime_state=" "$VG_PERSIST_FILE" >/dev/null 2>&1 \
        || return "$VG_ERR_INVALID"


    grep "^atomic_state=" "$VG_PERSIST_FILE" >/dev/null 2>&1 \
        || return "$VG_ERR_INVALID"


    grep "^transaction_state=" "$VG_PERSIST_FILE" >/dev/null 2>&1 \
        || return "$VG_ERR_INVALID"


    return "$VG_SUCCESS"

}



#
# Save runtime state
#

vg_persistence_save()
{

    runtime_state="$1"
    atomic_state="$2"
    transaction_state="$3"
    snapshot_id="$4"



    [ -n "$runtime_state" ] \
        || return "$VG_ERR_INVALID"


    [ -n "$atomic_state" ] \
        || return "$VG_ERR_INVALID"



    vg_persistence_prepare \
        || return $?



    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"



    cat > "$VG_PERSIST_TMP" <<EOF
timestamp=$timestamp
runtime_state=$runtime_state
atomic_state=$atomic_state
transaction_state=$transaction_state
snapshot_id=$snapshot_id
EOF



    [ -f "$VG_PERSIST_TMP" ] \
        || return "$VG_ERR_INTERNAL"



    mv -f "$VG_PERSIST_TMP" "$VG_PERSIST_FILE"



    [ -f "$VG_PERSIST_FILE" ] \
        || return "$VG_ERR_INTERNAL"



    return "$VG_SUCCESS"

}



#
# Check existence
#

vg_persistence_exists()
{

    [ -f "$VG_PERSIST_FILE" ]

}



#
# Load runtime state
#

vg_persistence_load()
{

    vg_persistence_validate \
        || return $?



    cat "$VG_PERSIST_FILE"


    return "$VG_SUCCESS"

}



#
# Get single value
#

vg_persistence_get()
{

    key="$1"


    [ -n "$key" ] \
        || return "$VG_ERR_INVALID"


    vg_persistence_validate \
        || return $?



    grep "^${key}=" "$VG_PERSIST_FILE" \
        | cut -d'=' -f2-



    return "$VG_SUCCESS"

}



#
# Clear persistence
#

vg_persistence_clear()
{

    rm -f "$VG_PERSIST_FILE" "$VG_PERSIST_TMP" 2>/dev/null


    return "$VG_SUCCESS"

}



#
# Status
#

vg_persistence_status()
{

    if [ -f "$VG_PERSIST_FILE" ]; then

        printf '%s\n' "saved"

    else

        printf '%s\n' "empty"

    fi


    return "$VG_SUCCESS"

}
