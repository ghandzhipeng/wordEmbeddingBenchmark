#! /bin/bash
#corpus_dir=w2.sub
#corpus_dir=w5.dyn.sub.del
#input_dir=${corpus_dir}
#input_dir=${corpus_dir}.graphs/java_pmi
input_dir=$1
pmi_array=( "pmi.thre.5" )
#pmi_array=( "pmi_0" "pmi_25" "pmi_50" "pmi_75" "pmi_100" )

neg_array=( "1" "3" "5" "7" "9" "11" )
#neg_array=( "1" )

# Evaluate on Word Similarity
#ana_array=( "google.txt" "msr.txt" )
#ws_array=( "bruni_men.txt" "radinsky_mturk.txt" "ws353_similarity.txt" "luong_rare.txt" "ws353_relatedness.txt" "ws353.txt" )
ws_array=( "radinsky_mturk.txt" "luong_rare.txt" "ws353_relatedness.txt" "ws353.txt" )
#ws_array=( "ws353.txt" )
#ana_array=( "google.txt" )

input_test_dir=../testsets
word_simi(){
    python ../hyperwords/ws_eval.py --neg $1   PPMI $2 $3 # 1 for neg, 2 for pmi_file, 3 for testset
#    python hyperwords/ws_eval.py --eig 0.5 SVD $1/svd $2
#    python hyperwords/ws_eval.py --w+c SGNS $1/sgns $2
}
word_analogy(){
    python ../hyperwords/analogy_eval.py --neg $1 PPMI --norm $2 $3
#    python hyperwords/analogy_eval.py --eig 0 SVD $1/svd $2 
#    python hyperwords/analogy_eval.py SGNS $1/sgns $2 
}


for ws_ele in ${ws_array[@]}
do
    for neg_ele in ${neg_array[@]}
    do

        for pmi_ele in ${pmi_array[@]}
        do
            echo "-----------------------------------------------"
            benchmark=$input_test_dir/ws/$ws_ele
            echo "word_simi" $neg_ele $input_dir/$pmi_ele $benchmark
            word_simi $neg_ele $input_dir/$pmi_ele $benchmark 
        done
    done 
done

