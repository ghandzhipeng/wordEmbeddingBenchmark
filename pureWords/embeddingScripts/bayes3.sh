#! /bin/bash

corpus_dir=$1
output_dir=${corpus_dir}.graphs/bayes3
mkdir -p $output_dir

echo "Embedding the $output_dir/id.edgelist"

node_num=`wc -l $output_dir/word_id.f | cut -d " " -f 1`
#let node_num=$node_num-1
echo "node number of the graph is $node_num"
path_train_data=$output_dir/id.edgelist
thread_num=8
path_simi=$output_dir/pmi
restart_rate=0
max_step=3
. ./funcs.sh
bayes_simi

echo "compile from id-simi to word-simi"
python idSimi2NodeSimi.py $path_simi $output_dir/word_id.f $output_dir/pmi.word.simi
echo "compile from CSR format to npz format"
python ../hyperwords/csr2npz.py $path_simi  $node_num $output_dir/word_id.f

