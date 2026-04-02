# ClickHouse pod bash 접속 (shard: 0-9, replica: 0-1)
# 사용 예: just ch 0 0
[group('ClickHouse pod 접속')]
ch shard replica:
    kubectl exec -it -n clickhouse chi-signoz-clickhouse-cluster-{{shard}}-{{replica}}-0 -- /bin/bash

# clickhouse-backup 컨테이너 bash 접속 (shard: 0-9, replica: 0-1)
# 사용 예: just backup 0 0
[group('ClickHouse pod 접속')]
backup shard replica:
    kubectl exec -it -n clickhouse chi-signoz-clickhouse-cluster-{{shard}}-{{replica}}-0 -c clickhouse-backup -- /bin/bash

# Zookeeper bash 접속 (node: 0-4)
# 사용 예: just zoo 0
[group('ClickHouse pod 접속')]
zoo node="0":
    kubectl exec -it -n clickhouse signoz-zookeeper-{{node}} -- /bin/bash

# ClickHouse pod 상태 조회
[group('클러스터 관리')]
pods:
    kubectl get pod -o wide -n clickhouse

# ClickHouse pod 상태 watch
[group('클러스터 관리')]
getpods:
    printf '\033]0;getpods\007'
    watch -n 1 kubectl get pod -o wide -n clickhouse

# clickhouse 네임스페이스 이벤트 watch
[group('클러스터 관리')]
event:
	printf '\033]0;event\007'
	while true; do \
		kubectl get events -n clickhouse --watch-only --request-timeout=0; \
		sleep 2; \
	done

# clickhouse-installation(CHI) 편집
[group('클러스터 관리')]
chi-edit:
    kubectl edit chi signoz-clickhouse -n clickhouse

# clickhouse-operator deployment 편집
[group('클러스터 관리')]
cho-edit:
    kubectl edit deployment signoz-clickhouse-operator -n clickhouse

# clickhouse-operator 로그 조회
[group('클러스터 관리')]
cho-log:
    printf '\033]0;cho-log\007'
    kubectl logs -n clickhouse -f deployment/signoz-clickhouse-operator

# ClickHouse pod 서버 로그 조회 (shard: 0-9, replica: 0-1)
# 사용 예: just log 0 0
[group('클러스터 관리')]
log shard replica:
    printf '\033]0;log {{shard}}-{{replica}}\007'
    kubectl logs -n clickhouse -f chi-signoz-clickhouse-cluster-{{shard}}-{{replica}}-0 -c clickhouse

# ClickHouse pod 삭제 (shard: 0-9, replica: 0-1)
# 사용 예: just del-pod 0 1
[group('클러스터 관리')]
del-pod shard replica:
    kubectl delete pod chi-signoz-clickhouse-cluster-{{shard}}-{{replica}}-0 -n clickhouse

# CHI(ClickHouseInstallation) 백업 (~/temp/chi-backup-MMDD-<region>.yaml)
# region은 현재 kubectl context에서 자동 추출
# 사용 예: just chi-backup
[group('클러스터 관리')]
chi-backup:
    #!/usr/bin/env bash
    context=$(kubectl config current-context)
    case "${context}" in
      aws-niffler2-dev-apse1-db-cluster)       region="dev" ;;
      aws-niffler2-dev-apse1-sandbox-cluster)  region="sd" ;;
      niffler2-stg-apse1-db-cluster)           region="stg" ;;
      niffler2-prod-apse1-db-cluster)          region="spc-ap" ;;
      niffler2-prod-use1-db-cluster)           region="spc-us" ;;
      niffler2-prod-euc1-db-cluster)           region="spc-eu" ;;
      aws-niffler2-prod-apse1-db-cluster)      region="aws-apse1" ;;
      aws-niffler2-prod-euw1-db-cluster)       region="aws-euw1" ;;
      aws-niffler2-prod-use2-db-cluster)       region="aws-use2" ;;
      *) echo "알 수 없는 context: ${context}"; exit 1 ;;
    esac
    mkdir -p ~/temp
    filename=~/temp/chi-backup-$(date +%m%d-%H%M)-${region}.yaml
    kubectl get chi signoz-clickhouse -n clickhouse -o yaml > "${filename}"
    echo "저장: ${filename}"
