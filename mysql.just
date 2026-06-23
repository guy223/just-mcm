# MySQL CLI 접속 (현재 kubectl context 자동 감지)
# db:  signoz_meta (기본값) | batch
# 사용 예: just mysql
#          just mysql batch
[group('MySQL CLI')]
mysql db="signoz_meta":
    #!/usr/bin/env bash
    set -euo pipefail
    context=$(kubectl config current-context)
    case "$context" in
      aws-niffler2-dev-apse1-db-cluster)  host="signoz-meta.ca1qbb5llq77.ap-southeast-1.rds.amazonaws.com" ;;
      niffler2-stg-apse1-db-cluster)      host="signoz-meta-stg.qc3en3lxwox2.rds.ap-southeast-1.samsungspc.cloud" ;;
      niffler2-prod-apse1-db-cluster)     host="signoz-meta-prod.qc3eh3ooinr6.rds.ap-southeast-1.samsungspc.cloud" ;;
      niffler2-prod-use1-db-cluster)      host="signoz-meta-prod.xmknh3ooinr6.rds.us-east-1.samsungspc.cloud" ;;
      niffler2-prod-euc1-db-cluster)      host="signoz-meta-prod.zbdch3ooinr6.rds.eu-central-1.samsungspc.cloud" ;;
      aws-niffler2-prod-apse1-db-cluster) host="signoz-meta.ccssy2wae8ic.ap-southeast-1.rds.amazonaws.com" ;;
      aws-niffler2-prod-use1-db-cluster)  host="signoz-meta.c4japxsjvnz6.us-east-1.rds.amazonaws.com" ;;
      aws-niffler2-prod-use2-db-cluster)  host="signoz-meta.cudecw6mumif.us-east-2.rds.amazonaws.com" ;;
      aws-niffler2-prod-euw1-db-cluster)  host="signoz-meta.cz4gvfysvog0.eu-west-1.rds.amazonaws.com" ;;
      *)   echo "지원하지 않는 context: $context"; exit 1 ;;
    esac

    if [[ "{{db}}" == "batch" ]]; then
      user="batch"
    else
      user="mcm"
    fi

    echo "context: $context"
    if kubectl get deployment mysql &>/dev/null; then
      kubectl exec -it deployment/mysql -- mysql -h"${host}" -P13306 -u"${user}" -p"${MYSQL_PASSWORD}" "{{db}}"
    else
      kubectl exec -it mysql -- mysql -h"${host}" -P13306 -u"${user}" -p"${MYSQL_PASSWORD}" "{{db}}"
    fi

# MySQL CLI 접속 (signoz_meta 고정, mcm 계정, 현재 context 자동 감지)
# 사용 예: just mysql-run
[group('MySQL CLI')]
mysql-run:
    #!/usr/bin/env bash
    set -euo pipefail
    context=$(kubectl config current-context)
    case "$context" in
      aws-niffler2-dev-apse1-db-cluster)  host="signoz-meta.ca1qbb5llq77.ap-southeast-1.rds.amazonaws.com" ;;
      niffler2-stg-apse1-db-cluster)      host="signoz-meta-stg.qc3en3lxwox2.rds.ap-southeast-1.samsungspc.cloud" ;;
      niffler2-prod-apse1-db-cluster)     host="signoz-meta-prod.qc3eh3ooinr6.rds.ap-southeast-1.samsungspc.cloud" ;;
      niffler2-prod-use1-db-cluster)      host="signoz-meta-prod.xmknh3ooinr6.rds.us-east-1.samsungspc.cloud" ;;
      niffler2-prod-euc1-db-cluster)      host="signoz-meta-prod.zbdch3ooinr6.rds.eu-central-1.samsungspc.cloud" ;;
      aws-niffler2-prod-apse1-db-cluster) host="signoz-meta.ccssy2wae8ic.ap-southeast-1.rds.amazonaws.com" ;;
      aws-niffler2-prod-use1-db-cluster)  host="signoz-meta.c4japxsjvnz6.us-east-1.rds.amazonaws.com" ;;
      aws-niffler2-prod-use2-db-cluster)  host="signoz-meta.cudecw6mumif.us-east-2.rds.amazonaws.com" ;;
      aws-niffler2-prod-euw1-db-cluster)  host="signoz-meta.cz4gvfysvog0.eu-west-1.rds.amazonaws.com" ;;
      *)   echo "지원하지 않는 context: $context"; exit 1 ;;
    esac

    echo "context: $context"
    if kubectl get deployment mysql &>/dev/null; then
      kubectl exec -it deployment/mysql -- mysql -h"${host}" -P13306 -umcm -p"${MYSQL_PASSWORD}" signoz_meta
    else
      kubectl exec -it mysql -- mysql -h"${host}" -P13306 -umcm -p"${MYSQL_PASSWORD}" signoz_meta
    fi
