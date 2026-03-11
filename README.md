# just-aliases

`~/.zshrc`의 kubectl alias들을 `just` 명령으로 통합 관리합니다.

## 설치

```bash
# 저장소 클론 (~/just 폴더로 고정)
git clone <repository-url> ~/just

# just 설치 (없는 경우)
# macOS
brew install just

# Linux (apt)
sudo apt-get install just

# 또는 Cargo로 설치
cargo install just

# alias 설정 (zsh)
echo 'alias j="just --justfile ~/just/justfile"' >> ~/.zshrc
source ~/.zshrc

# alias 설정 (bash)
echo 'alias j="just --justfile ~/just/justfile"' >> ~/.bashrc
source ~/.bashrc
```

## 사용법

```bash
# 전체 명령 목록 확인
j --list
```

## 명령 구조

### kubectl context 전환

```bash
# Dev
j dev          # aws-niffler2-dev-apse1-db-cluster
j sd           # aws-niffler2-dev-apse1-sandbox-cluster

# Staging
j stg          # niffler2-stg-apse1-db-cluster

# Production - SPC
j spc-ap       # niffler2-prod-apse1-db-cluster
j spc-us       # niffler2-prod-use1-db-cluster
j spc-eu       # niffler2-prod-euc1-db-cluster

# Production - AWS
j aws-apse1    # aws-niffler2-prod-apse1-db-cluster
j aws-euw1     # aws-niffler2-prod-euw1-db-cluster
j aws-use2     # aws-niffler2-prod-use2-db-cluster
```

### ClickHouse pod 접속

```bash
j ch 0 0       # shard 0, replica 0 bash
j ch 1 1       # shard 1, replica 1 bash
j backup 0 0   # shard 0, replica 0 backup 컨테이너
j zoo          # Zookeeper 0번 노드 bash (기본값)
j zoo 2        # Zookeeper 2번 노드 bash (0-4)
j pods         # ClickHouse pod 상태 watch
```

### MySQL CLI

```bash
# SPC 환경
j mysql dev         # dev signoz_meta
j mysql stg         # staging signoz_meta
j mysql spc-ap      # SPC AP prod signoz_meta
j mysql spc-us      # SPC US prod signoz_meta
j mysql spc-eu      # SPC EU prod signoz_meta

# AWS 환경
j mysql aws-apse1   # AWS AP-Southeast-1 signoz_meta
j mysql aws-use2    # AWS US-East-2 signoz_meta
j mysql aws-euw1    # AWS EU-West-1 signoz_meta

# batch DB (모든 환경 가능, batch 계정 사용)
j mysql spc-ap batch
j mysql aws-apse1 batch

# dev 환경에서 mysql pod 없을 때 임시 pod 생성
j mysql-run
```

## 파일 구조

| 파일 | 설명 |
|------|------|
| `justfile` | 메인 진입점, 모듈 import |
| `contexts.just` | kubectl context 전환 recipes |
| `clickhouse.just` | ClickHouse/Zookeeper pod exec recipes |
| `mysql.just` | MySQL CLI recipes |
