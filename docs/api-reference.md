# Project Vanguard API Reference

## Introduction

This document defines the public API exposed by Project Vanguard.

Functions documented here are considered stable once Vanguard reaches v1.0.0.

---

# Logger API

## vg_info

Logs an informational message.

Returns:

VG_SUCCESS

---

## vg_warn

Logs a warning message.

Returns:

VG_SUCCESS

---

## vg_error

Logs an error message.

Returns:

VG_SUCCESS

---

## vg_debug

Logs a debug message.

Returns:

VG_SUCCESS

---

# Configuration API

## vg_config_load

Loads framework configuration.

Returns:

VG_SUCCESS

VG_ERR_CONFIG

---

## vg_config_get

Gets a configuration value.

---

## vg_config_set

Sets a configuration value.

---

# Detection API

## vg_detect_device

Collects environment information.

Populates:

- VG_DEVICE
- VG_BRAND
- VG_MODEL
- VG_ANDROID
- VG_SDK
- VG_KERNEL
- VG_KERNELSU

---

# Validation API

## vg_validate_environment

Validates framework runtime.

Returns:

VG_SUCCESS

VG_ERR_UNSUPPORTED

VG_ERR_INTERNAL

---

# Bootstrap API

## vg_bootstrap

Framework entry point.

Responsible for:

- Configuration
- Validation
- Initialization

Returns:

VG_SUCCESS

or an error code.
