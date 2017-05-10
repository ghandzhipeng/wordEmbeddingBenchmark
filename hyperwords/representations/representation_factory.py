from embedding import SVDEmbedding, EnsembleEmbedding, Embedding
from explicit import PositiveExplicit


def create_representation(args):
    rep_type = args['<representation>']
    path = args['<representation_path>']
    neg = int(args['--neg'])
    w_c = args['--w+c']
    eig = float(args['--eig'])
    
    if rep_type == 'PPMI': # load matrix from an *.npz file.
        if w_c:
            raise Exception('w+c is not implemented for PPMI.')
        else:
            return PositiveExplicit(path, True, neg)
        
    elif rep_type == 'SVD': # load npy file. words.vocab, context.covab needed with respect to the embedding matrix.
        if w_c:
            return EnsembleEmbedding(SVDEmbedding(path, False, eig, False), SVDEmbedding(path, False, eig, True), True)
        else:
            return SVDEmbedding(path, True, eig)
        
    elif rep_type == "SGNS":
        if w_c:
            return EnsembleEmbedding(Embedding(path + '.words', False), Embedding(path + '.contexts', False), True)
        else:
            return Embedding(path + '.words', True)
    elif rep_type == "SIMI":
        if w_c:
            raise Exception('w+c is not implemented for SIMI.')
        else:
            # loadd embedding from *.npy matrix
            return Embedding(path, True)