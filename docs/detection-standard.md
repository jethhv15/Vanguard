# Detection Standard

All detection APIs must follow the rules below.

## Naming

Public functions must use:

vg_detect_<feature>()

Example:

- vg_detect_device()
- vg_detect_selinux()
- vg_detect_abi()

---

## Output

Detection functions must populate Project Vanguard global variables.

Example:

VG_DEVICE

VG_MODEL

VG_KERNEL

VG_SELINUX

---

## Return Codes

VG_SUCCESS

Detection completed successfully.

VG_ERR_UNSUPPORTED

Requested feature is unavailable.

VG_ERR_INTERNAL

Unexpected framework error.

---

## Logging

Detection functions must never produce log output.

Logging is the responsibility of the caller.

---

## Side Effects

Detection functions should only modify documented global variables.
