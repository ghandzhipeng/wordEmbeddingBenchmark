#!/bin/sh
corpus_dir=$1
output_dir=$corpus_dir/svd
python ../hyperwords/pmi2svd.py --dim 500 --neg 5 $output_dir/pmi $output_dir/svd

python ../hyperwords/ws_eval.py --eig 0.5 SVD $output_dir/svd ../testsets/ws/ws353.txt
#python ../hyperwords/analogy_eval.py --eig 0 SVD $output_dir/svd ../testsets/analogy/google.txt
