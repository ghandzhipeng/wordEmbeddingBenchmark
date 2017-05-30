#! /bin/bash
echo "bash _.sh output_dir path_simi"
output_dir=$1
path_simi=$2
node_num=`wc -l $output_dir/word_id.f | cut -d " " -f 1`
echo "compile from id-simi to word-simi"
#python idSimi2NodeSimi.py $path_simi $output_dir/word_id.f $output_dir/pmi.word.simi
echo "compile from CSR format to npz format"
python ../hyperwords/csr2npz.py $path_simi  $node_num $output_dir/word_id.f

