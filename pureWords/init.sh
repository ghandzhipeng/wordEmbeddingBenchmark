#! /bin/bash
#corpus_dir=w2.sub
corpus_dir=$1
mkdir -p $corpus_dir
mkdir -p $corpus_dir/sgns
mkdir -p $corpus_dir/line
mkdir -p $corpus_dir/svd
mkdir -p ${corpus_dir}.graphs
mkdir -p ${corpus_dir}.graphs/bayes3
mkdir -p ${corpus_dir}.graphs/java_pmi

mkdir -p tmp
#rm -r tmp
#mkdir -p tmp
#cp ../${corpus_dir}/pairs tmp/
#python cleanPairs.py  tmp/pairs > tmp/pairs.clean
bash ../scripts/pairs2counts.sh tmp/pairs.clean > tmp/counts
python ../hyperwords/counts2vocab.py tmp/counts
python ../hyperwords/counts2pmi.py --cds 1 tmp/counts tmp/pmi

cp tmp/pmi.words.vocab tmp/words.vocab

python genNode_id_f.py tmp/words.vocab tmp/word_id.f
python wordList2idList.py tmp/counts tmp/word_id.f tmp/id.edgelist

cp tmp/counts* tmp/pmi* ${corpus_dir}
cp tmp/counts* tmp/word_id.f tmp/words.vocab tmp/id.edgelist ${corpus_dir}.graphs/java_pmi
cp tmp/counts* tmp/word_id.f tmp/words.vocab tmp/id.edgelist ${corpus_dir}.graphs/bayes3

cp tmp/pairs.clean tmp/counts.* $corpus_dir/sgns
cp tmp/counts $corpus_dir/line

cp tmp/pmi.npz $corpus_dir/svd
cp tmp/pmi.words.vocab $corpus_dir/svd/svd.words.vocab
cp tmp/pmi.contexts.vocab $corpus_dir/svd/svd.contexts.vocab
