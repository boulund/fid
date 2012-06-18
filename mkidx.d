#!/usr/bin/env rdmd
/*
 Read byte positions of fasta entries
 Programmed in the D language
 Fredrik Boulund 20120613
*/

import std.getopt;
import std.string;
import std.stdio;


/*
  Reads a FASTA file line by line and counts
  byte positions to find file system coordinates to 
  fasta records for random access.
  Writes space-separated index to text file
*/
void findBytePositionsByLine(string fasta, string filename)
{
	bool first = true;
	string buffer;
	string prevheader;
	ulong curbytepos;
	ulong prevbytepos;
	File fastaFile = File(fasta, "rb");
	File databaseFile = File(filename, "wb");

	/* 
	  Go through the file, line by line, and store byte positions
	  for the first byte of each line starting with a '>', indicative
	  of the start of a FASTA record.
	*/
	buffer = fastaFile.readln();
	while (!fastaFile.eof())
	{
		/* 
		  The first record needs special treatment since we
		  do not know about the end byte position for this record
		*/
		if ((buffer[0] == '>') & first)
		{
			prevheader = buffer.split(" ")[0][1..$];
			prevbytepos = curbytepos;
			first = false;
		}
		else if (buffer[0] == '>')
		{
			// Write record to disk, format:
			// ^HEADER STARTPOS LENGTH$
			databaseFile.writefln("%s %s %s",
				prevheader, prevbytepos, curbytepos-prevbytepos+1);

			prevbytepos = curbytepos;
			prevheader = buffer.split(" ")[0][1..$];
		}
		curbytepos += buffer.length;
		buffer = fastaFile.readln();
	}

	/* Print the final fasta record information */
	databaseFile.writefln("%s %s %s", 
		prevheader, prevbytepos, cast(int) fastaFile.size());
	
	return;
}


void main(string[] args)
{
	findBytePositionsByLine(args[1], args[1]~".fidx");
}
