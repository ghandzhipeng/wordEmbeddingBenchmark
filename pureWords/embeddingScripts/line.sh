#! /bin/bash
corpus_dir=$1
output_dir=$1/line
line_out_name=line.words
./line -train $output_dir/counts -output $output_dir/$line_out_name -binary 0 -order 2 -size 200 -negative 15 -samples 50 -threads 16
python ../hyperwords/text2numpy.py $output_dir/$line_out_name
# evaluation
python ../hyperwords/ws_eval.py SGNS $output_dir/line ../testsets/ws/ws353.txt
#python ../hyperwords/analogy_eval.py SGNS $output_dir/line ../testsets/analogy/google.txt
