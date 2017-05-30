#! /bin/bash
output_dir=$1
# we already has counts file
# create pmi file from counts file
#python ../hyperwords/counts2pmi.py --cds 0. $output_dir/counts $output_dir/pmi_0 &
#python ../hyperwords/counts2pmi.py --cds 0.25 $output_dir/counts $output_dir/pmi_25 &
#python ../hyperwords/counts2pmi.py --cds 0.5 $output_dir/counts $output_dir/pmi_50 &
#python ../hyperwords/counts2pmi.py --cds 0.75 $output_dir/counts $output_dir/pmi_75 &
#python ../hyperwords/counts2pmi.py --cds 1.0 $output_dir/counts $output_dir/pmi_100 &
python ../hyperwords/counts2pmi.py --cds 0.85 $output_dir/counts $output_dir/pmi_85 &
