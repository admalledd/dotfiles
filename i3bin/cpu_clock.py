#!/usr/bin/python

def main(infopath="/proc/cpuinfo",atrib='cpu MHz'):
    processors = []
    with open(infopath,'r') as f:
        processors = f.read().replace('\t','').split('\n\n')

    clocks = []
    for processor in processors[:-1]:
        (_,pnum),(_,clock) = [p.split(':') for p in processor.split('\n') if p.strip() != '' and p.split(':')[0].strip() in ('processor',atrib)]
        clocks.append((pnum.strip(),clock.strip()))
    return clocks

if __name__ == '__main__':
    clocks = main()

    min_clock = min([float(c) for p,c in clocks])
    avg_clock = sum([float(c) for p,c in clocks])/len(clocks)
    max_clock = max([float(c) for p,c in clocks])

    import sys

    if len(sys.argv) == 1 or sys.argv[1] == 'all':
        for clock in clocks:
            print "cpu%s: %s MHz"%clock
        print ""
        print "min: %s MHz"%min_clock
        print "avg: %s MHz"%avg_clock
        print "max: %s MHz"%max_clock
    elif sys.argv[1] == 'avg':
        print "avg: %s MHz"%avg_clock
    elif sys.argv[1] == 'min':
        print "min: %s MHz"%min_clock
    elif sys.argv[1] == 'max':
        print "max: %s MHz"%max_clock
    elif sys.argv[1] == 'stat':
        print "min: %s MHz"%min_clock
        print "avg: %s MHz"%avg_clock
        print "max: %s MHz"%max_clock