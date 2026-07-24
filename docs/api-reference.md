## vg_info

### Description

Writes an informational message to the configured logger.

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| message | string | Yes | Message to log |

### Returns

| Code | Meaning |
|------|---------|
| VG_SUCCESS | Message processed successfully |
| VG_ERR_GENERAL | Invalid arguments |

### Side Effects

Writes to standard output if current log level allows it.

### Example

```sh
vg_info "Framework initialized"
```
