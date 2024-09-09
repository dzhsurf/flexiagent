#!/bin/bash
python text2sql_bird_benchmark.py \
    --mode "benchmark" \
    --db_root_path "../../../benchmark/bird/dev_20240627/dev_databases/" \
    --dataset_json "../../../benchmark/bird/dev_20240627/dev.json" \
    --pred_sql "pred.sql" \
    --gold_sql "../../../benchmark/bird/dev_20240627/dev.sql"