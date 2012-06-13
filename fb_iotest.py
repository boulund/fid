#!/usr/bin/env python
# Read byte positions of fasta entries
# Fredrik Boulund 20110701

from sys import argv, exit


with open(argv[1],"rb") as f:
    while True:
        # Read one byte ahead
        curchar = f.read(100000)
        if curchar == "":
            break
