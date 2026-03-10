# MySQL CLI 접속
# env: dev | stg | ap | us | eu
# db:  signoz_meta (기본값) | batch
# 사용 예: just mysql ap
#          just mysql ap batch
mysql env db="signoz_meta":
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{env}}" in
      dev) host="signoz-meta.ca1qbb5llq77.ap-southeast-1.rds.amazonaws.com" ;;
      stg) host="signoz-meta-stg.qc3en3lxwox2.rds.ap-southeast-1.samsungspc.cloud" ;;
      ap)  host="signoz-meta-prod.qc3eh3ooinr6.rds.ap-southeast-1.samsungspc.cloud" ;;
      us)  host="signoz-meta-prod.xmknh3ooinr6.rds.us-east-1.samsungspc.cloud" ;;
      eu)  host="signoz-meta-prod.zbdch3ooinr6.rds.eu-central-1.samsungspc.cloud" ;;
      *)   echo "❌ 알 수 없는 환경: {{env}}  (dev | stg | ap | us | eu)"; exit 1 ;;
    esac

    # ap 환경의 batch DB는 전용 계정 사용
    if [[ "{{env}}" == "ap" && "{{db}}" == "batch" ]]; then
      user="batch"
    else
      user="mcm"
    fi

    kubectl exec -it mysql -- mysql -h"${host}" -P13306 -u"${user}" -p"Zmffhdlt#2024" "{{db}}"
