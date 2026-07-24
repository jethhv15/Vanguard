# Project Vanguard Architecture

## Overview

Project Vanguard is an Android Performance Framework designed for KernelSU-based
devices. It provides a modular, maintainable, and extensible foundation for
building performance-related modules while maintaining compatibility across
Android versions.

Vanguard is not a tweak collection.

Vanguard is the platform that powers those tweaks.

---

# Objectives

- Provide reusable APIs for Android shell modules.
- Keep the codebase simple and maintainable.
- Maintain maximum compatibility with `/system/bin/sh`.
- Minimize technical debt.
- Support long-term open-source development.

---

# Engineering Principles

## KISS

Keep the implementation as simple as possible.

## DRY

Avoid duplicated code whenever possible.

## SRP

Each component has one responsibility.

Examples:

- logger.sh → Logging
- config.sh → Configuration
- detect.sh → Environment Detection
- validator.sh → Validation
- utils.sh → Shared Helpers

## Compatibility First

Every component should work using Android's default shell.

Avoid unnecessary Bash features.

## Small Commits

Each commit should introduce one logical change.

---

# Repository Structure

```
core/
config/
module/
runtime/
tests/
docs/
```

---

# Core Components

## bootstrap.sh

Framework entry point.

Responsible for:

- Loading components
- Loading configuration
- Running validation
- Starting framework

---

## logger.sh

Provides logging API.

Public API:

- vg_info
- vg_warn
- vg_error
- vg_debug

---

## config.sh

Provides configuration loading and access.

---

## detect.sh

Responsible for environment detection.

Examples:

- Device
- Brand
- Model
- Android Version
- SDK Version
- Kernel
- KernelSU

---

## validator.sh

Responsible for validating required runtime information.

---

## utils.sh

Reusable helper functions shared across the framework.

---

# Testing Philosophy

Every important bug should have a corresponding test.

Testing is part of development,
not something added afterward.

---

# Compatibility

Primary Target:

Android Shell

```
/system/bin/sh
```

Supported:

- KernelSU
- Modern Android versions

---

# Development Workflow

Design

↓

Implementation

↓

Review

↓

Testing

↓

Commit

---

# Versioning

Project Vanguard follows Semantic Versioning.

Examples:

- v0.1.0-alpha
- v0.2.0-beta
- v1.0.0

---

# Long-term Vision

Project Vanguard aims to become a reusable Android shell framework for
performance-related development rather than a collection of isolated scripts.
