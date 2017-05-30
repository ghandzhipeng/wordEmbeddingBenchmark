#! /bin/bash
#output_dir=w5.dyn.sub.del
output_dir=$1/sgns
../word2vecf/word2vecf -train $output_dir/pairs.clean -pow 0.75 -cvocab $output_dir/counts.contexts.vocab -wvocab $output_dir/counts.words.vocab -dumpcv $output_dir/sgns.contexts -output $output_dir/sgns.words -threads 15 -negative 15 -size 200 -iters 1
python ../hyperwords/text2numpy.py $output_dir/sgns.words
rm $output_dir/sgns.words
python ../hyperwords/text2numpy.py $output_dir/sgns.contexts
rm $output_dir/sgns.contexts

# evaluation
python ../hyperwords/ws_eval.py  SGNS $output_dir/sgns ../testsets/ws/ws353.txt
#python ../hyperwords/analogy_eval.py SGNS $output_dir/sgns ../testsets/analogy/google.txt
