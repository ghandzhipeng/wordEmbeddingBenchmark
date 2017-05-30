import sys
def has_digits(word):
    return any(char.isdigit() for char in word)

def cleanWord(word):
    # head
    c = word[0]
    if c < 'a' or c > 'z':
        word = word[1:]
    
    c = word[0]
    if c < 'a' or c > 'z':
        word = word[1:]
    # tail
    last = len(word) - 1 
    if last >= 0:
        c = word[last]
        if c < 'a' or c > 'z':
            word = word[:last]

    last = len(word) - 1 
    if last >= 0:
        c = word[last]
        if c < 'a' or c > 'z':
            word = word[:last]
    return word

def cleanPairs(inf):
    for line in open(inf):
        if line.startswith("#"):
            continue
        words = line.strip().split()
        if len(words) < 2:
            print 'words less than 2:', line
            sys.exit(1)
        if has_digits(words[0]) or has_digits(words[1]):
            continue
        print cleanWord(words[0]), cleanWord(words[1])

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print "python _.py counts.f"
        sys.exit(1)

    cleanPairs(sys.argv[1])
