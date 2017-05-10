#! /bin/bash
CORPUS="../corpus/news.2010.en.shuffled.clean"
out_dir="win1"

echo "generate the edges"
# python corpus2graph.py --sub 1e-5 $CORPUS > $out_dir/graphs.edgelist

echo "combine duplicate edges with weights representing the strength"
# ../scripts/pairs2counts.sh $out_dir/graphs.edgelist > $out_dir/weighted_graphs.edgelist

echo "generate the vocab file"
python ../hyperwords/counts2vocab.py $out_dir/weighted_graphs.edgelist

echo "map the weighted_edgelist graph"
python graph_mapper.py $out_dir/weighted_graphs.edgelist $out_dir/node_id.f $out_dir/id_edge.f

echo "Embedding the $out_dir/id_edge.f"
node_num=`wc -l $out_dir/node_id.f | cut -d " " -f 1`
let node_num=$node_num-1
echo "node number of the graph is $node_num"
path_train_data=$out_dir/id_edge.f
thread_num=16
path_simi=$out_dir/rpr.simi
. ./funcs.sh
rpr_simi

path_embedding=$out_dir/embeddings.file
echo "map $path_simi to $path_embedding"
python idSimi2NodeSimi.py $path_simi $out_dir/node_id.f $path_embedding

echo "compile $path_embedding into the format of numpy"
python ../hyperwords/text2numpy.py $path_embedding
