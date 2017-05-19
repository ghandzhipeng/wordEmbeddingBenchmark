#! /bin/bash
CORPUS="../corpus/news.2010.en.shuffled.clean"
out_dir="bayes-step3"
mkdir -p $out_dir
echo "generate the edges"
# python corpus2graph.py --sub 1e-5 $CORPUS > $out_dir/graphs.edgelist

echo "combine duplicate edges with weights representing the strength"
# ../scripts/pairs2counts.sh $out_dir/graphs.edgelist > $out_dir/weighted_graphs.edgelist

#cp ../w2.sub/counts $out_dir/weighted_graphs.edgelist
echo "generate the vocab file"
#python ../hyperwords/counts2vocab.py $out_dir/weighted_graphs.edgelist

echo "map the weighted_edgelist graph"
#python graph_mapper.py $out_dir/weighted_graphs.edgelist $out_dir/node_id.f $out_dir/id_edge.f

echo "Embedding the $out_dir/id_edge.f"
node_num=`wc -l $out_dir/node_id.f | cut -d " " -f 1`
let node_num=$node_num-1
echo "node number of the graph is $node_num"
path_train_data=$out_dir/id_edge.f
thread_num=16
restart_rate=0
max_step=3
path_simi=$out_dir/bayes.simi
. ./funcs.sh
#bayes_simi

# create svd from pmi information.
path_svd=$out_dir/svd
python ../hyperwords/pmi2svd.py --dim 500  $path_simi $path_svd
cp ${path_simi}.words.vocab ${path_svd}.words.vocab
cp ${path_simi}.contexts.vocab ${path_svd}.contexts.vocab
echo "compile from CSR format to npz format"
#python ../hyperwords/csr2npz.py $path_simi $node_num $out_dir/node_id.f

#echo "evaluation"
#python ../hyperwords/ws_eval.py PPMI $path_simi ../testsets/ws/ws353.txt
#python ../hyperwords/analogy_eval.py PPMI $path_simi ../testsets/analogy/google.txt
echo "evaluation"
python ../hyperwords/ws_eval.py SVD $path_svd ../testsets/ws/ws353.txt
python ../hyperwords/analogy_eval.py SVD $path_svd ../testsets/analogy/google.txt
