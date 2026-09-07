# just-aliases 프로젝트

## 프로젝트 개요

`~/.zshrc`에 흩어진 kubectl alias들을 `just` 명령으로 통합 관리하는 프로젝트.

## 디렉토리 구조

```
~/just/
├── justfile          # 메인 justfile (just 명령 진입점)
├── contexts.just     # kubectl context 전환 recipes
├── clickhouse.just   # ClickHouse pod exec recipes
├── mysql.just        # MySQL CLI recipes
├── CLAUDE.md
└── README.md
```

## alias 분류

### 1. kubectl context 전환 (`contexts.just`)

| recipe | context 이름 |
|--------|-------------|
| current | 현재 context 확인 |
| dev | aws-niffler2-dev-apse1-db-cluster |
| sd | aws-niffler2-dev-apse1-sandbox-cluster |
| aws-cn-dev | aws-niffler2-dev-cnw1-db-cluster |
| stg | niffler2-stg-apse1-db-cluster |
| spc-ap | niffler2-prod-apse1-db-cluster |
| spc-us | niffler2-prod-use1-db-cluster |
| spc-eu | niffler2-prod-euc1-db-cluster |
| aws-euw1 | aws-niffler2-prod-euw1-db-cluster |
| aws-use1 | aws-niffler2-prod-use1-db-cluster |
| aws-use2 | aws-niffler2-prod-use2-db-cluster |
| aws-cn-prod | aws-niffler2-prod-cnnw1-db-cluster |

### 2. ClickHouse pod exec (`clickhouse.just`)

| recipe | 설명 |
|--------|------|
| `ch <shard> <replica>` | ClickHouse pod bash (shard 0-9, replica 0-1) |
| `backup <shard> <replica>` | clickhouse-backup 컨테이너 bash |
| `zoo [node]` | Zookeeper bash (node 0-4, 기본값 0) |
| `pods` | ClickHouse pod 상태 조회 (1회) |
| `getpods` | ClickHouse pod 상태 watch (실시간) |
| `event` | clickhouse 네임스페이스 이벤트 watch |
| `chi-edit` | clickhouse-installation(CHI) 편집 |
| `cho-edit` | clickhouse-operator deployment 편집 |
| `cho-log` | clickhouse-operator 로그 조회 (실시간) |
| `log <shard> <replica>` | ClickHouse pod 서버 로그 조회 (shard 0-9, replica 0-1) |
| `chi-backup` | CHI YAML 백업 (~/temp/chi-backup-MMDD-<현재context>.yaml, region 자동 추출) |
| `del-pod <shard> <replica>` | ClickHouse pod 삭제 (shard 0-9, replica 0-1) |

### 3. MySQL CLI (`mysql.just`)

| recipe | 설명 |
|--------|------|
| `mysql [db]` | MySQL CLI 접속 (현재 kubectl context 자동 감지) |
| `mysql-run` | MySQL CLI 접속 (`signoz_meta` + `mcm` 계정 고정, 현재 context 자동 감지) |
| `mysql-query <sql> [db]` | MySQL 쿼리 non-interactive 실행 (`-e` 옵션, 현재 context 자동 감지) |

- db: `signoz_meta` (기본값) \| `batch` \| `grafana`
- `db=batch`이면 `batch` 계정 사용, 그 외는 `mcm` 계정
- `db=grafana`이면 `grafana-meta` RDS로 접속 (`aws-cn-dev` / `aws-cn-prod` context 전용, 그 외 context는 에러), 계정은 `niffler2_admin` 고정
- context → host 자동 매핑, 접속 전 현재 context 출력
- deployment/mysql 존재 시 deployment로, 없으면 pod 이름으로 접속

## 개발 규칙

- justfile은 모듈별로 분리하여 `import` 사용
- 자주 쓰는 명령은 짧은 recipe 이름 유지
- 새 클러스터/환경 추가 시 해당 모듈 파일만 수정
- `just --list`로 전체 명령 확인 가능하도록 주석(description) 작성
