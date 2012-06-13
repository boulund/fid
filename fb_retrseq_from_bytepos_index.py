#!/usr/bin/env python
# Retrieve sequences using bytepos index fasta entries
# Fredrik Boulund 20110701

from sys import argv, exit
import gc

# Disable the garbage collector
gc.disable()

if len(argv) < 2:
    print "usage: script.py file.fasta SEQID(s)..."
    exit()


# Open index-file                 
with open(argv[1]+".index") as index:
    # Open database file
    with open(argv[1],"rb") as seqfile:
        for line in index:
            for seqid in argv[2:]:
                if seqid in line:
                    # Information is stored on the lines as
                    # start\tend\tidentifier\n
                    information = line.split("\t")
                    start = int(information[0])
                    end = int(information[1])
                    seqfile.seek(start)
                    # Read the sequence for end-start number of bytes ahead
                    # Note that this will include the trailing newline
                    sequence = seqfile.read(end-start)
                    print sequence,
                


#def retrseq_bytepos(start, end):
#    """ Reads FASTA sequences from large files using byte positions"""
#    start = int(start)
#    end = int(end)
#    seqfile.seek(start,0)
#    sequence = seqfile.read(end-start)
#    return sequence
