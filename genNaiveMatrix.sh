#! /bin/bash
output_dir=w2.sub
python hyperwords/counts2cond.py --cds 0.75 $output_dir/counts $output_dir/cond
