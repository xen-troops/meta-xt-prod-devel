#!/bin/sh
### BEGIN INIT INFO
# Provides: vcpu-pin
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
### END INIT INFO

# Force all VCPUs of Domain-0 to only run on DOM0_ALLOWED_PCPUS PCPUs (A53 cores)
echo "Pinning Domain-0 VCPUs"
xl vcpu-pin Domain-0 all DOM0_ALLOWED_PCPUS
