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
VG_ERR_CONFIG=2
VG_ERR_UNSUPPORTED=3
VG_ERR_DEPENDENCY=4
VG_ERR_INTERNAL=5

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
VG_AUTHOR="Jethh"

#
# State 
#

VG_MODULE_STATE_DISCOVERED="discovered"
VG_MODULE_STATE_VALIDATED="validated"
VG_MODULE_STATE_LOADED="loaded"
VG_MODULE_STATE_STARTED="started"
VG_MODULE_STATE_STOPPED="stopped"
