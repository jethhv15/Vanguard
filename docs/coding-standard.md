# Project Vanguard Coding Standard

This document defines the coding rules for all shell scripts in Project Vanguard.

---

# 1. Compatibility

- All scripts MUST be compatible with `/system/bin/sh`.
- Bash-specific syntax is prohibited.

---

# 2. Public Functions

Public functions must use the following format:

vg_<feature>()

Example:

- vg_bootstrap()
- vg_detect_device()
- vg_config_load()

---

# 3. Private Functions

Private functions must use:

_vg_<feature>()

Example:

- _vg_timestamp()
- _vg_should_log()

---

# 4. Variables

Global variables must use:

VG_<NAME>

Private variables should use lowercase names.

Example:

VG_DEVICE
VG_KERNEL

level
message

---

# 5. Error Handling

Functions must return Project Vanguard error codes.

Never exit the shell from library functions.

---

# 6. Output

Library functions must not print unless their purpose is output.

Logging must only be performed by the logger component.

---

# 7. Comments

Every file should contain:

- File header
- Dependency section
- Global variables
- Private functions
- Public functions

---

# 8. Source Order

Recommended order:

1. Header
2. Dependencies
3. Global Variables
4. Private Functions
5. Public Functions

---

# 9. Formatting

- Use 4 spaces for indentation.
- Quote variable expansions.
- Keep functions focused on a single responsibility.

---

# 10. Commits

One logical change per commit.

Every commit must build upon a stable repository state.
