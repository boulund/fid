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
  fasta records for random access
*/
int[][string] findBytePositionsByLine(string fasta)
{
	bool first = true;
	string buffer;
	string prevheader;
	int curbytepos;
	int prevbytepos;
	int[][string] database;
	File fastaFile = File(fasta, "rb");

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
			database[prevheader] = [prevbytepos, curbytepos];
			prevbytepos = curbytepos;
			prevheader = buffer.split(" ")[0][1..$];
		}
		curbytepos += buffer.length;
		buffer = fastaFile.readln();
	}

	/* Add the final FASTA record to the database before returning */
	database[prevheader] = [prevbytepos, cast(int) fastaFile.size()];

	return database;
}

/* Writes database to simple text file*/
void writeDatabase(int[][string] database, string filename)
{
	File outFile = File(filename, "w");

	foreach (key, pos; database)
	{
		outFile.writefln("%s %s %s", key, pos[0], pos[1]);
	}
}

void main(string[] args)
{
	auto database = findBytePositionsByLine(args[1]);
	writeDatabase(database, args[1]~".fidx");	
}
