import sys

def genNodeId(words_f, out_f_name):
    outf = open(out_f_name, 'w')
    _id = 0
    for line in open(words_f):
        if line.startswith("#"):
            outf.write(line)
            continue
        line = line.strip()
        outf.write(line + " " + str(_id) + "\n")
        _id += 1

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print 'python _.py words.vocab word_id.f'
        sys.exit(1)

    genNodeId(sys.argv[1], sys.argv[2])

