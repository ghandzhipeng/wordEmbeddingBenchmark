#! /bin/bash
word_simi(){
    python hyperwords/ws_eval.py --neg 5 PPMI w2.sub/pmi $1
    python hyperwords/ws_eval.py --eig 0.5 SVD w2.sub/svd $1
    python hyperwords/ws_eval.py --w+c SGNS w2.sub/sgns $1
    
    python hyperwords/ws_eval.py --neg 5 PPMI w5.dyn.sub.del/pmi $1
    python hyperwords/ws_eval.py --eig 0.5 SVD w5.dyn.sub.del/svd $1
    python hyperwords/ws_eval.py --w+c SGNS w5.dyn.sub.del/sgns $1

}
word_analogy(){
    python hyperwords/analogy_eval.py PPMI w2.sub/pmi $1
    python hyperwords/analogy_eval.py --eig 0 SVD w2.sub/svd $1
    python hyperwords/analogy_eval.py SGNS w2.sub/sgns $1
    
    python hyperwords/analogy_eval.py PPMI w5.dyn.sub.del/pmi $1
    python hyperwords/analogy_eval.py --eig 0 SVD w5.dyn.sub.del/svd $1
    python hyperwords/analogy_eval.py SGNS w5.dyn.sub.del/sgns $1
}
input=testsets

# Evaluate on Word Similarity
ws_array=( "bruni_men.txt" "radinsky_mturk.txt" "ws353_similarity.txt" "luong_rare.txt" "ws353_relatedness.txt" "ws353.txt" )
for element in ${ws_array[@]}
do
    echo "-----------------------------------------------"
    benchmark=$input/ws/$element
    echo $benchmark
    word_simi $benchmark
done

# Evaluate on Analogies
ana_array=( "google.txt" "msr.txt" )
for element in ${ana_array[@]}
do
    echo "-----------------------------------------------"
    benchmark=$input/analogy/$element
    echo $benchmark
    word_analogy $benchmark
done
