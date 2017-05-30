#! /usr/bin/python
import sys
def main(f_name, threshold):
    outf = open(f_name + ".thre." + str(threshold), 'w')
    for line in open(f_name):
        values = line.strip().split()
        if float(values[2]) < float(threshold):
            continue
        else:
            outf.write(line)
    outf.close()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print "python _.py pmi.file threshold"
        sys.exit(1)

    main(sys.argv[1], sys.argv[2])
