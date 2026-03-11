# 현재 kubectl context 확인
current:
    kubectl config current-context

# ── Dev ──────────────────────────────────────────────────────────────────────

# Dev DB 클러스터 (AP-SE1)
dev:
    kubectl config use-context aws-niffler2-dev-apse1-db-cluster

# Dev Sandbox 클러스터 (AP-SE1)
sd:
    kubectl config use-context aws-niffler2-dev-apse1-sandbox-cluster

# ── Staging ───────────────────────────────────────────────────────────────────

# Staging DB 클러스터 (AP-SE1)
stg:
    kubectl config use-context niffler2-stg-apse1-db-cluster

# ── Production - SPC ──────────────────────────────────────────────────────────

# SPC Prod DB 클러스터 (AP-SE1)
spc-ap:
    kubectl config use-context niffler2-prod-apse1-db-cluster

# SPC Prod DB 클러스터 (US-E1)
spc-us:
    kubectl config use-context niffler2-prod-use1-db-cluster

# SPC Prod DB 클러스터 (EU-C1)
spc-eu:
    kubectl config use-context niffler2-prod-euc1-db-cluster

# ── Production - AWS ──────────────────────────────────────────────────────────

# AWS Prod DB 클러스터 (AP-SE1)
aws-apse1:
    kubectl config use-context aws-niffler2-prod-apse1-db-cluster

# AWS Prod DB 클러스터 (EU-W1)
aws-euw1:
    kubectl config use-context aws-niffler2-prod-euw1-db-cluster

# AWS Prod DB 클러스터 (US-E2)
aws-use2:
    kubectl config use-context aws-niffler2-prod-use2-db-cluster
