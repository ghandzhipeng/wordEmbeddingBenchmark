#! /bin/bash
output_dir=w5.dyn.sub.del
#output_dir=w2.sub
word2vecf/word2vecf -train $output_dir/pairs -pow 0.75 -cvocab $output_dir/counts.contexts.vocab -wvocab $output_dir/counts.words.vocab -dumpcv $output_dir/sgns.contexts -output $output_dir/sgns.words -threads 15 -negative 15 -size 200 -iters 4
python hyperwords/text2numpy.py $output_dir/sgns.words
rm $output_dir/sgns.words
python hyperwords/text2numpy.py $output_dir/sgns.contexts
rm $output_dir/sgns.contexts

# evaluation
python hyperwords/ws_eval.py  SGNS $output_dir/sgns testsets/ws/ws353.txt
python hyperwords/analogy_eval.py SGNS $output_dir/sgns testsets/analogy/google.txt

#line_out_name=line.words
#./line -train $output_dir/counts -output $output_dir/$line_out_name -binary 0 -order 2 -size 200 -negative 15 -samples 512 -threads 16
#python hyperwords/text2numpy.py $output_dir/$line_out_name
## evaluation
#python hyperwords/ws_eval.py SGNS $output_dir/line testsets/ws/ws353.txt
#python hyperwords/analogy_eval.py SGNS $output_dir/line testsets/analogy/google.txt
