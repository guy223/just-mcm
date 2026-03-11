# 현재 kubectl context 확인
[group('클러스터 관리')]
current:
    kubectl config current-context

# ── Dev ──────────────────────────────────────────────────────────────────────

# Dev DB 클러스터 (AP-SE1)
[group('context 전환')]
dev:
    kubectl config use-context aws-niffler2-dev-apse1-db-cluster

# Dev Sandbox 클러스터 (AP-SE1)
[group('context 전환')]
sd:
    kubectl config use-context aws-niffler2-dev-apse1-sandbox-cluster

# ── Staging ───────────────────────────────────────────────────────────────────

# Staging DB 클러스터 (AP-SE1)
[group('context 전환')]
stg:
    kubectl config use-context niffler2-stg-apse1-db-cluster

# ── Production - SPC ──────────────────────────────────────────────────────────

# SPC Prod DB 클러스터 (AP-SE1)
[group('context 전환')]
spc-ap:
    kubectl config use-context niffler2-prod-apse1-db-cluster

# SPC Prod DB 클러스터 (US-E1)
[group('context 전환')]
spc-us:
    kubectl config use-context niffler2-prod-use1-db-cluster

# SPC Prod DB 클러스터 (EU-C1)
[group('context 전환')]
spc-eu:
    kubectl config use-context niffler2-prod-euc1-db-cluster

# ── Production - AWS ──────────────────────────────────────────────────────────

# AWS Prod DB 클러스터 (AP-SE1)
[group('context 전환')]
aws-apse1:
    kubectl config use-context aws-niffler2-prod-apse1-db-cluster

# AWS Prod DB 클러스터 (EU-W1)
[group('context 전환')]
aws-euw1:
    kubectl config use-context aws-niffler2-prod-euw1-db-cluster

# AWS Prod DB 클러스터 (US-E2)
[group('context 전환')]
aws-use2:
    kubectl config use-context aws-niffler2-prod-use2-db-cluster
