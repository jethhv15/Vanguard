# Project Vanguard API Reference

## API Stability

Public APIs documented in this file are considered stable.

Breaking changes MUST NOT be introduced without a major version increment.

---

# Logger API

## vg_info(message)

### Description

Logs an informational message.

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| message | string | Yes | Message to log |

### Returns

| Code | Description |
|------|-------------|
| VG_SUCCESS | Message processed successfully |
| VG_ERR_GENERAL | Invalid arguments |

---

## vg_warn(message)

Same behavior as `vg_info()` using WARN level.

---

## vg_error(message)

Same behavior as `vg_info()` using ERROR level.

---

## vg_debug(message)

Same behavior as `vg_info()` using DEBUG level.

---

# Configuration API

## vg_config_load()

Loads configuration into runtime.

Returns:

- VG_SUCCESS
- VG_ERR_CONFIG

---

## vg_config_get(name)

Returns configuration value.

---

## vg_config_set(name, value)

Updates runtime configuration.

---

# Detection API

## vg_detect_device()

Collects environment information.

Populates:

- VG_DEVICE
- VG_BRAND
- VG_MODEL
- VG_ANDROID
- VG_SDK
- VG_KERNEL
- VG_KERNELSU

Returns:

VG_SUCCESS

---

# Validation API

## vg_validate_environment()

Validates runtime environment.

Returns:

- VG_SUCCESS
- VG_ERR_UNSUPPORTED
- VG_ERR_INTERNAL

---

# Bootstrap API

## vg_bootstrap()

Framework initialization entry point.

Returns:

- VG_SUCCESS
- Framework error code
