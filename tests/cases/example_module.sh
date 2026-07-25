#!/system/bin/sh

. "$CORE_DIR/loader.sh"

vg_load_module "modules/example"

result=$?

if [ "$result" -eq "$VG_SUCCESS" ]; then
    exit 0
fi

exit 1
