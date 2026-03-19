# MySQL CLI 접속
# env: dev | stg | spc-ap | spc-us | spc-eu | aws-apse1 | aws-use2 | aws-euw1
# db:  signoz_meta (기본값) | batch
# 사용 예: just mysql spc-ap
#          just mysql spc-ap batch
#          just mysql aws-apse1
[group('MySQL CLI')]
mysql env db="signoz_meta":
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{env}}" in
      dev)       host="signoz-meta.ca1qbb5llq77.ap-southeast-1.rds.amazonaws.com" ;;
      stg)       host="signoz-meta-stg.qc3en3lxwox2.rds.ap-southeast-1.samsungspc.cloud" ;;
      spc-ap)    host="signoz-meta-prod.qc3eh3ooinr6.rds.ap-southeast-1.samsungspc.cloud" ;;
      spc-us)    host="signoz-meta-prod.xmknh3ooinr6.rds.us-east-1.samsungspc.cloud" ;;
      spc-eu)    host="signoz-meta-prod.zbdch3ooinr6.rds.eu-central-1.samsungspc.cloud" ;;
      aws-apse1) host="signoz-meta.ccssy2wae8ic.ap-southeast-1.rds.amazonaws.com" ;;
      aws-use2)  host="signoz-meta.cudecw6mumif.us-east-2.rds.amazonaws.com" ;;
      aws-euw1)  host="signoz-meta.cz4gvfysvog0.eu-west-1.rds.amazonaws.com" ;;
      *)   echo "알 수 없는 환경: {{env}}  (dev | stg | spc-ap | spc-us | spc-eu | aws-apse1 | aws-use2 | aws-euw1)"; exit 1 ;;
    esac

    # batch DB는 batch 계정 사용, 그 외는 mcm 계정
    if [[ "{{db}}" == "batch" ]]; then
      user="batch"
    else
      user="mcm"
    fi

    kubectl exec -it mysql -- mysql -h"${host}" -P13306 -u"${user}" -p"${MYSQL_PASSWORD}" "{{db}}"

# Dev 환경에서 MySQL pod 없을 때 임시 pod 생성 후 signoz_meta 접속 (dev 전용)
# 사용 예: just mysql-run
[group('MySQL CLI')]
mysql-run:
    kubectl run --image mysql --env LC_ALL=C.UTF-8 mysql -it -- \
      /bin/bash -c "mysql -hsignoz-meta.ca1qbb5llq77.ap-southeast-1.rds.amazonaws.com -P13306 signoz_meta -umcm -p${MYSQL_PASSWORD}"
