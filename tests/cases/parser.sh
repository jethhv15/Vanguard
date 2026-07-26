#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/parser.sh"


vg_assert_return_code \
    "$VG_ERR_NOT_FOUND" \
    "$(vg_parse_manifest "/does/not/exist" >/dev/null 2>&1; echo $?)" \
    "Parser should fail when manifest does not exist"



mkdir -p "$TEST_DIR/fixtures/parser"


cat > "$TEST_DIR/fixtures/parser/module.prop" <<EOF
id=test
name=Parser Test
version=1.0
versionCode=1
author=Test
api=1
entry=module.sh
depends=network,performance
EOF


vg_parse_manifest \
    "$TEST_DIR/fixtures/parser/module.prop"


vg_assert_equal \
    "network,performance" \
    "$VG_MODULE_DEPENDS" \
    "Parser should read module dependencies"
