#!/system/bin/sh
#
# Project Vanguard
# Persistence Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/persistence.sh"



vg_persistence_clear



status="$(vg_persistence_status)"

vg_assert_true \
"[ \"\$status\" = \"empty\" ]" \
"Persistence initial state"



vg_persistence_save \
"running" \
"committed" \
"idle" \
"snapshot01"


rc=$?

vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Persistence save completed"



exists=0

vg_persistence_exists && exists=1


vg_assert_true \
"[ \$exists -eq 1 ]" \
"Persistence file exists"



runtime="$(vg_persistence_get runtime_state)"

vg_assert_true \
"[ \"\$runtime\" = \"running\" ]" \
"Runtime state restored"



atomic="$(vg_persistence_get atomic_state)"

vg_assert_true \
"[ \"\$atomic\" = \"committed\" ]" \
"Atomic state restored"



loaded="$(vg_persistence_load)"


vg_assert_true \
"[ -n \"\$loaded\" ]" \
"Persistence load returns data"



vg_persistence_clear


status="$(vg_persistence_status)"


vg_assert_true \
"[ \"\$status\" = \"empty\" ]" \
"Persistence clear completed"
