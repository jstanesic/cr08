#!/bin/bash
# Run on LIN1 with sudo: sudo /opt/scripts/Verify-LabA1.sh
set -uo pipefail

ok=true

# 1 — Pacemaker HA_Service_Group must be Started
if sudo pcs status 2>/dev/null | grep -q 'HA_Service_Group.*Started'; then
    echo '[PASS] HA_Service_Group is Started in the Pacemaker cluster'
else
    echo '[FAIL] HA_Service_Group is not Started — check: sudo pcs status'
    ok=false
fi

# 2 — Windows Failover Cluster IP must respond
if ping -c1 -W2 192.168.1.50 >/dev/null 2>&1; then
    echo '[PASS] Windows Failover Cluster IP 192.168.1.50 is reachable'
else
    echo '[FAIL] Windows Failover Cluster IP 192.168.1.50 is not reachable'
    ok=false
fi

if $ok; then
    echo ''
    echo 'Passkey: ha-cluster-verified'
fi
