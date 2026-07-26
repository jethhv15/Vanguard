#!/system/bin/sh
#
# Project Vanguard
# Shared Constants
#


#
# Return Codes
#

VG_SUCCESS=0

VG_ERR_GENERAL=1
VG_ERR_INVALID=2
VG_ERR_CONFIG=3
VG_ERR_UNSUPPORTED=4
VG_ERR_DEPENDENCY=5
VG_ERR_INTERNAL=6
VG_ERR_NOT_FOUND=7
VG_ERR_PERMISSION=8
VG_ERR_STATE=9
VG_ERR_EXISTS=10



#
# Log Levels
#

VG_LOG_INFO="INFO"
VG_LOG_WARN="WARN"
VG_LOG_ERROR="ERROR"
VG_LOG_DEBUG="DEBUG"



#
# Project Information
#

VG_NAME="Project Vanguard"
VG_VERSION="0.1.0"
VG_API_VERSION=1
VG_AUTHOR="Jethh"



#
# Runtime Storage
#
# Single source of truth
#

if [ -z "${VG_RUNTIME_DIR:-}" ]; then

    if [ -d "/data/adb" ] && [ -w "/data/adb" ]; then

        VG_RUNTIME_DIR="/data/adb/vanguard/runtime"

    else

        VG_RUNTIME_DIR="$CORE_DIR/../runtime"

    fi

fi



#
# Runtime Files
#

VG_AUDIT_FILE="$VG_RUNTIME_DIR/audit.log"

VG_PERSIST_FILE="$VG_RUNTIME_DIR/runtime.state"

VG_RECOVERY_DIR="$VG_RUNTIME_DIR/recovery"

VG_SNAPSHOT_DIR="$VG_RUNTIME_DIR/snapshot"

VG_TRUST_FILE="$VG_RUNTIME_DIR/trust.db"



#
# Module State
#

VG_MODULE_STATE_DISCOVERED="discovered"

VG_MODULE_STATE_VALIDATED="validated"

VG_MODULE_STATE_LOADED="loaded"

VG_MODULE_STATE_STARTED="started"

VG_MODULE_STATE_STOPPED="stopped"



#
# Resume State
#

VG_RESUME_IDLE="idle"
VG_RESUME_CHECKING="checking"
VG_RESUME_FRESH="fresh"
VG_RESUME_RESTORING="restoring"
VG_RESUME_RESTORED="restored"
VG_RESUME_RECOVERY="recovery"
VG_RESUME_FAILED="failed"



#
# Transaction State
#

VG_TRANSACTION_IDLE="idle"
VG_TRANSACTION_RUNNING="running"
VG_TRANSACTION_COMMITTED="committed"
VG_TRANSACTION_ROLLBACK="rolledback"



#
# Atomic State
#

VG_ATOMIC_IDLE="idle"
VG_ATOMIC_RUNNING="running"
VG_ATOMIC_COMMITTED="committed"
VG_ATOMIC_FAILED="failed"
VG_ATOMIC_ROLLEDBACK="rolledback"



#
# Engine State
#

VG_ENGINE_IDLE="idle"
VG_ENGINE_BOOTING="booting"
VG_ENGINE_READY="ready"
VG_ENGINE_FAILED="failed"



#
# Security State
#

VG_TRUST_UNKNOWN="unknown"
VG_TRUST_TRUSTED="trusted"
VG_TRUST_BLOCKED="blocked"



#
# Sandbox State
#

VG_SANDBOX_DISABLED="disabled"
VG_SANDBOX_ENABLED="enabled"



#
# Permission Types
#

VG_PERMISSION_ROOT="root"
VG_PERMISSION_FILESYSTEM="filesystem"
VG_PERMISSION_NETWORK="network"
VG_PERMISSION_KERNEL="kernel"
VG_PERMISSION_SYSTEM="system"
