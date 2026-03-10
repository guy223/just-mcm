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
