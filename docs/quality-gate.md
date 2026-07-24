# Project Vanguard Quality Gate

Every change merged into the project should satisfy the following quality checks.

## Static Analysis

- [ ] ShellCheck completed.
- [ ] No unresolved ShellCheck warnings unless documented.

---

## Testing

- [ ] All test cases pass.
- [ ] No regression introduced.

---

## Documentation

- [ ] Documentation matches implementation.
- [ ] Public API documentation is up to date.

---

## Compatibility

- [ ] Compatible with `/system/bin/sh`.
- [ ] No Bash-specific features introduced.
- [ ] Android compatibility verified.

---

## Release

A release candidate should only be created after all quality gates are satisfied.
