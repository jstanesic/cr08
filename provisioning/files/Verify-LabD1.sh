#!/bin/bash
# Run on LIN4: /opt/scripts/Verify-LabD1.sh
set -uo pipefail

ok=true

# 1 — HAProxy must be active (restored after the LB failure scenario)
if systemctl is-active --quiet haproxy; then
    echo '[PASS] HAProxy is active'
else
    echo '[FAIL] HAProxy is not active — check: systemctl status haproxy'
    ok=false
fi

# 2 — Web application must be reachable through the load balancer
if curl -sf http://localhost 2>/dev/null | grep -q 'Server'; then
    echo '[PASS] Web application is accessible through HAProxy'
else
    echo '[FAIL] Web application not responding — check backend servers and HAProxy config'
    ok=false
fi

if $ok; then
    echo ''
    echo 'Passkey: bcp-drill-complete'
fi
