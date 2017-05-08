#! /bin/bash
CORPUS=news.2010.en.shuffled

#python hyperwords/corpus2graph.py --sub 1e-5 ${CORPUS}.clean > graphs/graphs.edgelist
#scripts/pairs2counts.sh graphs/graphs.edgelist > graphs/weighted_graphs.edgelist
python hyperwords/counts2vocab.py graphs/weighted_graphs.edgelist


