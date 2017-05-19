#!/bin/sh

# Download and install word2vecf
if [ ! -d word2vecf ]; then
    scripts/install_word2vecf.sh
fi

# Download corpus. We chose a small corpus for the example, and larger corpora will yield better results.
CORPUS=corpus/news.2010.en.shuffled
if [ ! -f $CORPUS ]; then
    wget http://www.statmt.org/wmt14/training-monolingual-news-crawl/news.2010.en.shuffled.gz
    gzip -d news.2010.en.shuffled.gz
    scripts/clean_corpus.sh $CORPUS > $CORPUS.clean
fi

# A) Window size 2 with "clean" subsampling
output_dir=w2.sub
#mkdir $output_dir -p
#python hyperwords/corpus2pairs.py --win 2 --sub 1e-5 ${CORPUS}.clean > $output_dir/pairs
#scripts/pairs2counts.sh $output_dir/pairs > $output_dir/counts
#python hyperwords/counts2vocab.py $output_dir/counts
# Calculate PMI matrices for each collection of pairs
python hyperwords/counts2pmi.py --cds 0.75 $output_dir/counts $output_dir/pmi
# Create embeddings with SVD
#python hyperwords/pmi2svd.py --dim 500 --neg 5 $output_dir/pmi $output_dir/svd
#cp $output_dir/pmi.words.vocab $output_dir/svd.words.vocab
#cp $output_dir/pmi.contexts.vocab $output_dir/svd.contexts.vocab
# Create embeddings with SGNS (A). 
#word2vecf/word2vecf -train $output_dir/pairs -pow 0.75 -cvocab $output_dir/counts.contexts.vocab -wvocab $output_dir/counts.words.vocab -dumpcv $output_dir/sgns.contexts -output $output_dir/sgns.words -threads 16 -negative 15 -size 500;
#python hyperwords/text2numpy.py $output_dir/sgns.words
#rm $output_dir/sgns.words
#python hyperwords/text2numpy.py $output_dir/sgns.contexts
#rm $output_dir/sgns.contexts

# B) Window size 5 with dynamic contexts and "dirty" subsampling

output_dir=w5.dyn.sub.del
mkdir $output_dir -p
#python hyperwords/corpus2pairs.py --win 5 --dyn --sub 1e-5 --del ${CORPUS}.clean > $output_dir/pairs
#scripts/pairs2counts.sh $output_dir/pairs > $output_dir/counts
#python hyperwords/counts2vocab.py $output_dir/counts
## Calculate PMI matrices for each collection of pairs
python hyperwords/counts2pmi.py --cds 0.75 $output_dir/counts $output_dir/pmi
## Create embeddings with SVD
#python hyperwords/pmi2svd.py --dim 500 --neg 5 $output_dir/pmi $output_dir/svd
#cp $output_dir/pmi.words.vocab $output_dir/svd.words.vocab
#cp $output_dir/pmi.contexts.vocab $output_dir/svd.contexts.vocab
## Create embeddings with SGNS (A). 
#word2vecf/word2vecf -train $output_dir/pairs -pow 0.75 -cvocab $output_dir/counts.contexts.vocab -wvocab $output_dir/counts.words.vocab -dumpcv $output_dir/sgns.contexts -output $output_dir/sgns.words -threads 16 -negative 15 -size 500;
#python hyperwords/text2numpy.py $output_dir/sgns.words
#rm $output_dir/sgns.words
#python hyperwords/text2numpy.py $output_dir/sgns.contexts
#rm $output_dir/sgns.contexts


## Evaluate on Word Similarity
#echo "WS353 Results"
#echo "-------------"
#
#python hyperwords/ws_eval.py --neg 10000 PPMI w2.sub/pmi testsets/ws/ws353.txt
#python hyperwords/ws_eval.py --eig 0.5 SVD w2.sub/svd testsets/ws/ws353.txt
#python hyperwords/ws_eval.py --w+c SGNS w2.sub/sgns testsets/ws/ws353.txt
#
#python hyperwords/ws_eval.py --neg 5 PPMI w5.dyn.sub.del/pmi testsets/ws/ws353.txt
#python hyperwords/ws_eval.py --eig 0.5 SVD w5.dyn.sub.del/svd testsets/ws/ws353.txt
#python hyperwords/ws_eval.py --w+c SGNS w5.dyn.sub.del/sgns testsets/ws/ws353.txt
#
#
## Evaluate on Analogies
#echo "Google Analogy Results"
#echo "----------------------"
#
#python hyperwords/analogy_eval.py --neg 10000 PPMI w2.sub/pmi testsets/analogy/google.txt
#python hyperwords/analogy_eval.py --eig 0 SVD w2.sub/svd testsets/analogy/google.txt
#python hyperwords/analogy_eval.py SGNS w2.sub/sgns testsets/analogy/google.txt
#
#python hyperwords/analogy_eval.py PPMI w5.dyn.sub.del/pmi testsets/analogy/google.txt
#python hyperwords/analogy_eval.py --eig 0 SVD w5.dyn.sub.del/svd testsets/analogy/google.txt
#python hyperwords/analogy_eval.py SGNS w5.dyn.sub.del/sgns testsets/analogy/google.txt
