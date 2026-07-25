#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/parser.sh"

vg_assert_return_code \
    "$VG_ERR_NOT_FOUND" \
    "$(vg_parse_manifest "/does/not/exist" >/dev/null 2>&1; echo $?)" \
    "Parser should fail when manifest does not exist"
