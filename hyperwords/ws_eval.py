from docopt import docopt
from scipy.stats.stats import spearmanr

from representations.representation_factory import create_representation


def main():
    args = docopt("""
    Usage:
        ws_eval.py [options] <representation> <representation_path> <task_path>
    
    Options:
        --neg NUM    Number of negative samples; subtracts its log from PMI (only applicable to PPMI) [default: 1]
        --w+c        Use ensemble of word and context vectors (not applicable to PPMI)
        --eig NUM    Weighted Component of word and context vectors [default: 0.5]
        --norm       whether normalize 
    """)
    
    data = read_test_set(args['<task_path>'])
    representation = create_representation(args)
    correlation = evaluate(representation, data)
    print "representation\tpmi_file\tneg_num\tnorm\ttask_path\taccuracy"
    print args['<representation>'], args['<representation_path>'], args['--neg'], args['--norm'], args['<task_path>'], '\t%0.3f' % correlation


def read_test_set(path):
    test = []
    with open(path) as f:
        for line in f:
            x, y, sim = line.strip().lower().split()
            test.append(((x, y), sim))
    return test 


def evaluate(representation, data):
    not_in = 0
    total = 0
    results = []
    for (x, y), sim in data:
        computed_sim = representation.similarity(x, y)
        # print computed_sim, sim
        if computed_sim == 0:
            not_in += 1
        total += 1
        results.append((computed_sim, sim))
    actual, expected = zip(*results)
    print "total_question:", total, "total number of zeros:", not_in
    return spearmanr(actual, expected)[0]


if __name__ == '__main__':
    main()
