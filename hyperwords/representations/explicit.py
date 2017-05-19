import heapq

from scipy.sparse import dok_matrix, csr_matrix
import numpy as np

from matrix_serializer import load_vocabulary, load_matrix


class Explicit:
    """
    Base class for explicit representations. Assumes that the serialized input is e^PMI.
    LOAD matrix from a *.npz file.
    """
    
    def __init__(self, path, normalize=True):
        # 'wi' is a dict {word: id}, 'iw' is a list: [word].
        self.wi, self.iw = load_vocabulary(path + '.words.vocab')
        self.ci, self.ic = load_vocabulary(path + '.contexts.vocab')
        self.m = load_matrix(path)
        self.m.data = np.log(self.m.data)
        self.normal = normalize
        if normalize:
            self.normalize()
    
        self.f_debug = open("numerical_value", 'a') 
    
    def normalize(self):
        m2 = self.m.copy()
        m2.data **= 2
        #norm = np.reciprocal(np.sqrt(np.array(m2.sum(axis=1))[:, 0]))
        # modify to avoid the divide zero error.
        norm = np.sqrt(np.array(m2.sum(axis=1))[:, 0])
        for i in xrange(0, len(norm)):
            if norm[i] == 0:
                continue
            else:
                norm[i] = 1. / norm[i]

        normalizer = dok_matrix((len(norm), len(norm)))
        normalizer.setdiag(norm)
        self.m = normalizer.tocsr().dot(self.m)
    
    def represent(self, w):
        if w in self.wi:
            return self.m[self.wi[w], :]
        else:
            # contruct a empty csr_matrix with a 1*len shape.
            return csr_matrix((1, len(self.ic)))
    
    def similarity_first_order(self, w, c):
        return self.m[self.wi[w], self.ci[c]]

    def similarity(self, w1, w2):
        """
        Assumes the vectors have been normalized.
        """
        w1_vec = self.represent(w1)
        w2_vec = self.represent(w2)
        print w1, w1_vec.getnnz()
        f_debug = self.f_debug
        x = w1_vec.toarray()[0]
        for i in x:
            f_debug.write(str(i) + " ")
        f_debug.write("\n")
        print w2, w2_vec.getnnz()
        x = w2_vec.toarray()[0]
        for i in x:
            f_debug.write(str(i) + " ")
        f_debug.write("\n")
        return self.represent(w1).dot(self.represent(w2).T)[0, 0]
    
    def closest_contexts(self, w, n=10):
        """
        Assumes the vectors have been normalized.
        """
        scores = self.represent(w)
        return heapq.nlargest(n, zip(scores.data, [self.ic[i] for i in scores.indices]))
    
    def closest(self, w, n=10):
        """
        Assumes the vectors have been normalized.
        """
        scores = self.m.dot(self.represent(w).T).T.tocsr()
        return heapq.nlargest(n, zip(scores.data, [self.iw[i] for i in scores.indices]))


class PositiveExplicit(Explicit):
    """
    Positive PMI (PPMI) with negative sampling (neg).
    Negative samples shift the PMI matrix before truncation.
    """
    
    def __init__(self, path, normalize=True, neg=1):
        Explicit.__init__(self, path, False)
        self.m.data -= np.log(neg)
        self.m.data[self.m.data < 0] = 0
        #self.m.data[self.m.data < np.log(neg)] = 0
        # removes zero entries from CSR matrix.
        self.m.eliminate_zeros()
        if normalize:
            self.normalize()
