# MySQL CLI 접속 (현재 kubectl context 자동 감지)
# db:  signoz_meta (기본값) | batch | grafana (aws-cn-dev / aws-cn-prod 전용)
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
      aws-niffler2-prod-use1-db-cluster)  host="signoz-meta.c4japxsjvnz6.us-east-1.rds.amazonaws.com" ;;
      aws-niffler2-prod-use2-db-cluster)  host="signoz-meta.cudecw6mumif.us-east-2.rds.amazonaws.com" ;;
      aws-niffler2-prod-euw1-db-cluster)  host="signoz-meta.cz4gvfysvog0.eu-west-1.rds.amazonaws.com" ;;
      aws-niffler2-dev-cnw1-db-cluster)   host="signoz-meta.cxeskoyw0lqx.rds.cn-northwest-1.amazonaws.com.cn"; grafana_host="grafana-meta.cxeskoyw0lqx.rds.cn-northwest-1.amazonaws.com.cn" ;;
      aws-niffler2-prod-cnnw1-db-cluster) host="signoz-meta.chqqiy6ye7s2.rds.cn-northwest-1.amazonaws.com.cn"; grafana_host="grafana-meta.chqqiy6ye7s2.rds.cn-northwest-1.amazonaws.com.cn" ;;
      *)   echo "지원하지 않는 context: $context"; exit 1 ;;
    esac

    if [[ "{{db}}" == "batch" ]]; then
      user="batch"
    elif [[ "{{db}}" == "grafana" ]]; then
      if [[ -z "${grafana_host:-}" ]]; then
        echo "db=grafana는 aws-cn-dev / aws-cn-prod context에서만 지원합니다: $context"; exit 1
      fi
      host="$grafana_host"
      user="niffler2_admin"
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
      aws-niffler2-prod-use1-db-cluster)  host="signoz-meta.c4japxsjvnz6.us-east-1.rds.amazonaws.com" ;;
      aws-niffler2-prod-use2-db-cluster)  host="signoz-meta.cudecw6mumif.us-east-2.rds.amazonaws.com" ;;
      aws-niffler2-prod-euw1-db-cluster)  host="signoz-meta.cz4gvfysvog0.eu-west-1.rds.amazonaws.com" ;;
      aws-niffler2-dev-cnw1-db-cluster)   host="signoz-meta.cxeskoyw0lqx.rds.cn-northwest-1.amazonaws.com.cn"; grafana_host="grafana-meta.cxeskoyw0lqx.rds.cn-northwest-1.amazonaws.com.cn" ;;
      aws-niffler2-prod-cnnw1-db-cluster) host="signoz-meta.chqqiy6ye7s2.rds.cn-northwest-1.amazonaws.com.cn"; grafana_host="grafana-meta.chqqiy6ye7s2.rds.cn-northwest-1.amazonaws.com.cn" ;;
      *)   echo "지원하지 않는 context: $context"; exit 1 ;;
    esac

    echo "context: $context"
    if kubectl get deployment mysql &>/dev/null; then
      kubectl exec -it deployment/mysql -- mysql -h"${host}" -P13306 -umcm -p"${MYSQL_PASSWORD}" signoz_meta
    else
      kubectl exec -it mysql -- mysql -h"${host}" -P13306 -umcm -p"${MYSQL_PASSWORD}" signoz_meta
    fi

# MySQL 쿼리 non-interactive 실행 (현재 kubectl context 자동 감지)
# db:  signoz_meta (기본값) | batch | grafana (aws-cn-dev / aws-cn-prod 전용)
# 사용 예: just mysql-query "SELECT 1;"
#          just mysql-query "SELECT * FROM foo;" batch
[group('MySQL CLI')]
mysql-query sql db="signoz_meta":
    #!/usr/bin/env bash
    set -euo pipefail
    context=$(kubectl config current-context)
    case "$context" in
      aws-niffler2-dev-apse1-db-cluster)  host="signoz-meta.ca1qbb5llq77.ap-southeast-1.rds.amazonaws.com" ;;
      niffler2-stg-apse1-db-cluster)      host="signoz-meta-stg.qc3en3lxwox2.rds.ap-southeast-1.samsungspc.cloud" ;;
      niffler2-prod-apse1-db-cluster)     host="signoz-meta-prod.qc3eh3ooinr6.rds.ap-southeast-1.samsungspc.cloud" ;;
      niffler2-prod-use1-db-cluster)      host="signoz-meta-prod.xmknh3ooinr6.rds.us-east-1.samsungspc.cloud" ;;
      niffler2-prod-euc1-db-cluster)      host="signoz-meta-prod.zbdch3ooinr6.rds.eu-central-1.samsungspc.cloud" ;;
      aws-niffler2-prod-use1-db-cluster)  host="signoz-meta.c4japxsjvnz6.us-east-1.rds.amazonaws.com" ;;
      aws-niffler2-prod-use2-db-cluster)  host="signoz-meta.cudecw6mumif.us-east-2.rds.amazonaws.com" ;;
      aws-niffler2-prod-euw1-db-cluster)  host="signoz-meta.cz4gvfysvog0.eu-west-1.rds.amazonaws.com" ;;
      aws-niffler2-dev-cnw1-db-cluster)   host="signoz-meta.cxeskoyw0lqx.rds.cn-northwest-1.amazonaws.com.cn"; grafana_host="grafana-meta.cxeskoyw0lqx.rds.cn-northwest-1.amazonaws.com.cn" ;;
      aws-niffler2-prod-cnnw1-db-cluster) host="signoz-meta.chqqiy6ye7s2.rds.cn-northwest-1.amazonaws.com.cn"; grafana_host="grafana-meta.chqqiy6ye7s2.rds.cn-northwest-1.amazonaws.com.cn" ;;
      *)   echo "지원하지 않는 context: $context"; exit 1 ;;
    esac

    if [[ "{{db}}" == "batch" ]]; then
      user="batch"
    elif [[ "{{db}}" == "grafana" ]]; then
      if [[ -z "${grafana_host:-}" ]]; then
        echo "db=grafana는 aws-cn-dev / aws-cn-prod context에서만 지원합니다: $context"; exit 1
      fi
      host="$grafana_host"
      user="niffler2_admin"
    else
      user="mcm"
    fi

    echo "context: $context"
    if kubectl get deployment mysql &>/dev/null; then
      kubectl exec deployment/mysql -- mysql -h"${host}" -P13306 -u"${user}" -p"${MYSQL_PASSWORD}" "{{db}}" -e "{{sql}}"
    else
      kubectl exec mysql -- mysql -h"${host}" -P13306 -u"${user}" -p"${MYSQL_PASSWORD}" "{{db}}" -e "{{sql}}"
    fi
