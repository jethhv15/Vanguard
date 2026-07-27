. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/diagnostic.sh"


vg_diag_set \
"TEST" \
"example" \
"failed sample" \
"$VG_ERR_GENERAL"


vg_assert_equal \
"TEST" \
"$VG_DIAG_STAGE" \
"Diagnostic stage stored"


vg_assert_equal \
"example" \
"$VG_DIAG_MODULE" \
"Diagnostic module stored"


vg_assert_equal \
"failed sample" \
"$VG_DIAG_REASON" \
"Diagnostic reason stored"
