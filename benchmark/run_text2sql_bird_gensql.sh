#!/bin/bash
python text2sql_bird_benchmark.py \
    --mode "gensql" \
    --db_root_path "../../../benchmark/bird/dev_20240627/dev_databases/" \
    --dataset_json "../../../benchmark/bird/dev_20240627/dev.json" 