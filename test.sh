#! /bin/bash
word_simi(){
    python hyperwords/ws_eval.py --neg 5 PPMI $1/pmi $2
    python hyperwords/ws_eval.py --eig 0.5 SVD $1/svd $2
    python hyperwords/ws_eval.py --w+c SGNS $1/sgns $2
}
word_analogy(){
    python hyperwords/analogy_eval.py PPMI $1/pmi $2 
    python hyperwords/analogy_eval.py --eig 0 SVD $1/svd $2 
    python hyperwords/analogy_eval.py SGNS $1/sgns $2 
}
input_test_dir=testsets

ws_array=( "bruni_men.txt" "radinsky_mturk.txt" "ws353_similarity.txt" "luong_rare.txt" "ws353_relatedness.txt" "ws353.txt" )
ana_array=( "google.txt" "msr.txt" )
# Evaluate on Word Similarity
input_dir=w2.sub.directed
for element in ${ws_array[@]}
do
    echo "-----------------------------------------------"
    benchmark=$input_test_dir/ws/$element
    echo $benchmark
    word_simi $input_dir $benchmark
done

# Evaluate on Analogies
for element in ${ana_array[@]}
do
    echo "-----------------------------------------------"
    benchmark=$input_test_dir/analogy/$element
    echo $benchmark
    word_analogy $input_dir $benchmark
done

# Evaluate on Word Similarity
input_dir=w5.dyn.sub.del.directed
for element in ${ws_array[@]}
do
    echo "-----------------------------------------------"
    benchmark=$input_test_dir/ws/$element
    echo $benchmark
    word_simi $input_dir $benchmark
done

# Evaluate on Analogies
for element in ${ana_array[@]}
do
    echo "-----------------------------------------------"
    benchmark=$input_test_dir/analogy/$element
    echo $benchmark
    word_analogy $input_dir $benchmark
done

