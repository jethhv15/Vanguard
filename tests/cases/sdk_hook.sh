#!/system/bin/sh

. "$CORE_DIR/sdk/sdk.sh"

vg_register_hook() {
    return 0
}

vg_hook_register "boot" "module_boot" || exit 1

exit 0
