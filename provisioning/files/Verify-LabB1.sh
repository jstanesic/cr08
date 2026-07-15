#!/bin/bash
# Run on LIN4: /opt/scripts/Verify-LabB1.sh
set -uo pipefail

ok=true

# 1 — HAProxy must be active
if systemctl is-active --quiet haproxy; then
    echo '[PASS] HAProxy is active'
else
    echo '[FAIL] HAProxy is not active — check: systemctl status haproxy'
    ok=false
fi

# 2 — Load balancer must return content from a backend server
if curl -sf http://localhost >/dev/null 2>&1; then
    echo '[PASS] HAProxy is serving responses from the backend'
else
    echo '[FAIL] No response from HAProxy at localhost'
    ok=false
fi

if $ok; then
    echo ''
    echo 'Passkey: haproxy-balanced'
fi
