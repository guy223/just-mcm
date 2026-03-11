# ClickHouse pod bash 접속 (shard: 0-9, replica: 0-1)
# 사용 예: just ch 0 0
ch shard replica:
    kubectl exec -it -n clickhouse chi-signoz-clickhouse-cluster-{{shard}}-{{replica}}-0 -- /bin/bash

# clickhouse-backup 컨테이너 bash 접속 (shard: 0-9, replica: 0-1)
# 사용 예: just backup 0 0
backup shard replica:
    kubectl exec -it -n clickhouse chi-signoz-clickhouse-cluster-{{shard}}-{{replica}}-0 -c clickhouse-backup -- /bin/bash

# Zookeeper bash 접속 (node: 0-4)
# 사용 예: just zoo 0
zoo node="0":
    kubectl exec -it -n clickhouse signoz-zookeeper-{{node}} -- /bin/bash

# ClickHouse pod 상태 watch
pods:
    watch -n 1 kubectl get pod -o wide -n clickhouse

# clickhouse 네임스페이스 이벤트 watch
event:
    kubectl events -n clickhouse -w

# clickhouse-operator deployment 편집
chi-edit:
    kubectl edit deployment signoz-clickhouse-operator -n clickhouse

# ClickHouse pod 삭제 (shard: 0-9, replica: 0-1)
# 사용 예: just del-pod 0 1
del-pod shard replica:
    kubectl delete pod chi-signoz-clickhouse-cluster-{{shard}}-{{replica}}-0 -n clickhouse

# CHI(ClickHouseInstallation) 백업 (~/temp/chi-backup-MMDD-<region>.yaml)
# 사용 예: just chi-backup spc-ap
chi-backup region:
    #!/usr/bin/env bash
    mkdir -p ~/temp
    filename=~/temp/chi-backup-$(date +%m%d)-{{region}}.yaml
    kubectl get chi signoz-clickhouse -n clickhouse -o yaml > "${filename}"
    echo "저장: ${filename}"
