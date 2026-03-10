import 'contexts.just'
import 'clickhouse.just'
import 'mysql.just'

# 전체 명령 목록 표시
default:
    @just --list --justfile {{justfile()}}
