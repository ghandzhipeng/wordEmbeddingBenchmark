import sys

def wordList2idList(wordlist_f, word_id_f, out_f_name):
    word2id = dict()
    for line in open(word_id_f):
        if line.startswith('#'):
            continue
        line = line.strip().split()
        word2id[line[0]] = line[1]

    outf = open(out_f_name, 'w')

    for line in open(wordlist_f):
        if line.startswith("#"):
            outf.write(line)
            continue
        line = line.strip().split()
        outf.write(line[0] + " " + word2id[line[1]] + " "+ word2id[line[2]] + "\n")

    outf.close()
if __name__ == '__main__':
    if len(sys.argv) < 4:
        print 'python _.py counts word_id.f id.edgelist'
        sys.exit(1)

    wordList2idList(sys.argv[1], sys.argv[2], sys.argv[3])
