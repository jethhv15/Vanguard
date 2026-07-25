#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/loader.sh"

vg_load_module "modules/example"

result=$?

if [ "$result" -eq "$VG_SUCCESS" ]; then
    exit 0
fi

exit 1
