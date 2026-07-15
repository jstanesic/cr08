#!/bin/bash
# Run on LIN4: /opt/scripts/Verify-LabC1.sh
set -uo pipefail

ok=true

# 1 — Grafana must be active (Prometheus + Grafana installed in Phase 2)
if systemctl is-active --quiet grafana-server; then
    echo '[PASS] Grafana is active'
else
    echo '[FAIL] Grafana is not active — check: systemctl status grafana-server'
    ok=false
fi

# 2 — Prometheus must have at least one target in "up" state
if curl -sf http://localhost:9090/api/v1/targets 2>/dev/null | grep -q '"health":"up"'; then
    echo '[PASS] Prometheus has healthy scrape targets'
else
    echo '[FAIL] No healthy Prometheus targets — check: curl http://localhost:9090/api/v1/targets'
    ok=false
fi

if $ok; then
    echo ''
    echo 'Passkey: rto-validated'
fi
