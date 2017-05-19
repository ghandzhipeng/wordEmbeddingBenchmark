from docopt import docopt
from scipy.sparse import dok_matrix, csr_matrix
import numpy as np

from representations.matrix_serializer import save_matrix, save_vocabulary, load_count_vocabulary


def main():
    args = docopt("""
    Usage:
        counts2cond.py [options] <counts> <output_path>
    
    Options:
        --cds NUM    Context distribution smoothing [default: 1.0]
    """)
    
    counts_path = args['<counts>']
    vectors_path = args['<output_path>']
    cds = float(args['--cds'])
    
    counts, iw, ic = read_counts_matrix(counts_path)

    cond = calc_cond(counts, cds)

    save_matrix(vectors_path, cond) # pmi is a CSR matrix.
    save_vocabulary(vectors_path + '.words.vocab', iw)
    save_vocabulary(vectors_path + '.contexts.vocab', ic)


def read_counts_matrix(counts_path):
    """
    Reads the counts into a sparse matrix (CSR) from the count-word-context textual format.
    """
    words = load_count_vocabulary(counts_path + '.words.vocab')
    contexts = load_count_vocabulary(counts_path + '.contexts.vocab')
    words = list(words.keys())
    contexts = list(contexts.keys())
    iw = sorted(words) # words without counts, also the order is different from that in counts.words.vocab
    ic = sorted(contexts)
    wi = dict([(w, i) for i, w in enumerate(iw)]) # wi is a dict {word: id}
    ci = dict([(c, i) for i, c in enumerate(ic)])
    
    counts = csr_matrix((len(wi), len(ci)), dtype=np.float32)

    # csr matrix is composed of three arrays,
    # row = np.array([0, 0, 1, 2, 2, 2])
    # col = np.array([0, 2, 2, 0, 1, 2])
    # data = np.array([1, 2, 3, 4, 5, 6])
    # mtx = sparse.csr_matrix((data, (row, col)), shape=(3, 3)).

    tmp_counts = dok_matrix((len(wi), len(ci)), dtype=np.float32)
    # dictionary of keys based sparse matrix.
    update_threshold = 100000
    i = 0
    with open(counts_path) as f:
        for line in f:
            count, word, context = line.strip().split()
            if word in wi and context in ci:
                tmp_counts[wi[word], ci[context]] = int(count)
            i += 1
            if i == update_threshold:
                counts = counts + tmp_counts.tocsr()
                tmp_counts = dok_matrix((len(wi), len(ci)), dtype=np.float32)
                i = 0
    counts = counts + tmp_counts.tocsr()
    
    return counts, iw, ic


def calc_cond(counts, cds):
    """
    Calculates e^cond; cond without the log().
    p(c|w)
    """
    sum_w = np.array(counts.sum(axis=1))[:, 0]
    sum_c = np.array(counts.sum(axis=0))[0, :]
    if cds != 1:
        sum_c = sum_c ** cds
    sum_total = sum_c.sum()
    sum_w = np.reciprocal(sum_w)
    #sum_c = np.reciprocal(sum_c)
    
    cond = csr_matrix(counts)
    cond = multiply_by_rows(cond, sum_w)
    cond = cond * sum_total
    # if cds==1, sum_total is the total number of tokens in a corpus, maybe millions or billions.
    # rather than 30k words in vocabs.

    return cond


def multiply_by_rows(matrix, row_coefs):
    normalizer = dok_matrix((len(row_coefs), len(row_coefs)))
    normalizer.setdiag(row_coefs)
    return normalizer.tocsr().dot(matrix)


def multiply_by_columns(matrix, col_coefs):
    normalizer = dok_matrix((len(col_coefs), len(col_coefs)))
    normalizer.setdiag(col_coefs)
    return matrix.dot(normalizer.tocsr())


if __name__ == '__main__':
    main()
