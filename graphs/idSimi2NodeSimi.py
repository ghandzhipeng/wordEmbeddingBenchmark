import sys

def convert(embedding_f, node2id_f, out_embedding_f):
    id2word = dict()
    for line in open(node2id_f):
        if line.startswith('#') or line.strip() == "":
            continue
        line = line.strip().split()
        _word = line[0]
        _id = line[1]
        id2word[_id] = _word

    out_embedding_file = open(out_embedding_f, 'w')
    first_line = True
    for line in open(embedding_f):
        if first_line:
            out_embedding_file.write(line)
            first_line = False
            continue
        line = line.strip().split()
        line[0] = id2word[line[0]]
        # print line[0]
        out_embedding_file.write(" ".join(line) + "\n")

    out_embedding_file.close()

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print 'Usage: python _.py embedding.file node2id.file out_embedding.file'
        sys.exit(1)
    convert(sys.argv[1], sys.argv[2], sys.argv[3])
