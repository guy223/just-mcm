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
| dev | aws-niffler2-dev-apse1-db-cluster |
| sd | aws-niffler2-dev-apse1-sandbox-cluster |
| stg | niffler2-stg-apse1-db-cluster |
| spc-ap | niffler2-prod-apse1-db-cluster |
| spc-us | niffler2-prod-use1-db-cluster |
| spc-eu | niffler2-prod-euc1-db-cluster |
| aws-apse1 | aws-niffler2-prod-apse1-db-cluster |
| aws-euw1 | aws-niffler2-prod-euw1-db-cluster |
| aws-use2 | aws-niffler2-prod-use2-db-cluster |

### 2. ClickHouse pod exec (`clickhouse.just`)

| recipe | 설명 |
|--------|------|
| `ch <shard> <replica>` | ClickHouse pod bash (shard 0-9, replica 0-1) |
| `backup <shard> <replica>` | clickhouse-backup 컨테이너 bash |
| `zoo [node]` | Zookeeper bash (node 0-4, 기본값 0) |
| `pods` | ClickHouse pod 상태 watch |

### 3. MySQL CLI (`mysql.just`)

| recipe | 설명 |
|--------|------|
| `mysql <env> [db]` | MySQL CLI 접속 |

- env: `dev` \| `stg` \| `ap` \| `us` \| `eu`
- db: `signoz_meta` (기본값) \| `batch`
- `ap` + `batch` 조합은 `batch` 계정 사용, 나머지는 `mcm` 계정

## 개발 규칙

- justfile은 모듈별로 분리하여 `import` 사용
- 자주 쓰는 명령은 짧은 recipe 이름 유지
- 새 클러스터/환경 추가 시 해당 모듈 파일만 수정
- `just --list`로 전체 명령 확인 가능하도록 주석(description) 작성
