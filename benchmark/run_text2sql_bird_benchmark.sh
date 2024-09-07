#!/bin/bash
python text2sql_bird_benchmark.py \
    --predicted_sql_path "<YOUR_PREDICTED_SQL>" \
    --ground_truth_path "../../../benchmark/bird/dev_20240627/dev.sql" \
    --db_root_path "../../../benchmark/bird/dev_20240627/dev_databases/" \
    --diff_json_path "../../../benchmark/bird/dev_20240627/dev.json" \
    --num_cpus 8 \
    --sql_dialect "SQLite" 