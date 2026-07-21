#!/bin/bash
# Run on LIN1 with sudo: sudo /opt/scripts/Verify-LabA1.sh
set -uo pipefail

ok=true

# 1 — Pacemaker HA_Service_Group must be Started
if sudo pcs status 2>/dev/null | grep -iq 'SharedFS.*Started' && \
   sudo pcs status 2>/dev/null | grep -iq 'VirtualIP.*Started' && \
   sudo pcs status 2>/dev/null | grep -iq 'MySqlService.*Started'; then
    echo '[PASS] HA_Service_Group resources (SharedFS, VirtualIP, MySqlService) are Started'
else
    echo '[FAIL] One or more HA_Service_Group resources are not Started — check: sudo pcs status'
    ok=false
fi

# 2 — Windows Failover Cluster IP must respond
if ping -c1 -W2 10.10.10.50 >/dev/null 2>&1; then
    echo '[PASS] Windows Failover Cluster IP 10.10.10.50 is reachable'
else
    echo '[FAIL] Windows Failover Cluster IP 10.10.10.50 is not reachable'
    ok=false
fi

if $ok; then
    echo ''
    echo 'Passkey: ha-cluster-verified'
fi
