#!/usr/bin/env python
# Read byte positions of fasta entries
# Fredrik Boulund 20110701

from sys import argv, exit
import io


#if len(argv) < 2:
#    print "usage: script.py file.fasta"
#    exit()

READBUFFER = int(1e5)

buffer = " "
curbytepos = 0
bytepositions = []
identifiers = []

# THE FOLLOWING WORKS BUT IS KIND OF SLOW ON LARGE FILES...
# This implementation uses the standard Binary I/O interface
# BufferedIOBase
with open(argv[1],"rb") as f:
    while True:
        # Read one byte ahead
        buffer = f.read(READBUFFER)
        # Break if no more bytes to read!
        if not buffer:
            break
        else:
            for byte in buffer:
                if byte == ">":
                    pass
                    ## Reset the identifier string
                    #curidentifier = ""
                    ## Found a fasta header, store position
                    #bytepositions.append(curbytepos)
                    #curchar = f.read(1)
                    #curbytepos += 1
                    ## Now read until the next space and store this in a string
                    #while curchar != " ":
                    #    curidentifier = ''.join([curidentifier,curchar])
                    #    curchar = f.read(1)
                    #    curbytepos += 1
                    #identifiers.append(curidentifier)
                # Increment the bytepos counter
                curbytepos += 1
    # Store the file size (current byte pos since we're at the end now)
    filesize = curbytepos

## Write the byte positions and identifier strings to a file
#with open(argv[1]+".index","w") as outfile:
#    for i, identifier in enumerate(identifiers):
#        try:
#            outfile.write('\t'.join([str(bytepositions[i]),
#                                     str(bytepositions[i+1]),
#                                     identifier,"\n"]))
#        except IndexError: #last pos+1 is invalid
#            outfile.write('\t'.join([str(bytepositions[i]),
#                                     str(filesize),
#                                     identifier, "\n"]))
