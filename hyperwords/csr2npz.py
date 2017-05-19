from docopt import docopt
import numpy as np
from scipy.sparse import csr_matrix

from representations.matrix_serializer import save_vocabulary, save_matrix


def main():
    args = docopt("""
    Usage:
        csr2npz.py <simi_path> <node_num> <node_id>
    """)
    # Only used for full rank information. LIKE graph-based measures like PMI-simulation, rootedPageRank.
    simi_path = args['<simi_path>']
    node_num = int(args['<node_num>'])
    node_id = args['<node_id>']

    row = []
    col = []
    data = []

    for line in open(simi_path):
        line = line.strip().split()
        row.append(int(line[0]))
        col.append(int(line[1]))
        data.append(float(line[2]))
    save_matrix(simi_path, csr_matrix( (data, (row, col)), shape=(node_num, node_num)))

    id_node = [None] * node_num
    for line in open(node_id):
        if line.startswith("#"):
            continue
        line = line.strip().split()
        _id = int(line[1])
        _node = line[0]
        id_node[_id] = _node

    save_vocabulary(simi_path + '.words.vocab', id_node)
    save_vocabulary(simi_path + '.contexts.vocab', id_node)


if __name__ == '__main__':
    main()
