#!/usr/bin/env rdmd
/*
 Using previously stored byte index from mkfid,
 retrieves fasta sequences using regexp matching 
 to sequence keys
 Programmed in the D language
 Fredrik Boulund 20120614
*/

import std.getopt;
//import std.string;
import std.stdio;
import std.file;
import std.regex;



/*
 Read FASTA index (FID) database from file
*/
int[2][string] readFID(string filename)
{
	int[2][string] database;

	/* 
	  Read formatted lines
	  ^HEADER STARTPOS ENDPOS$
	*/
	auto records = slurp!(string, int, int)(filename, "%s %s %s");
	foreach (record; records)
	{
		database[record[0]] = [record[1], record[2]];
	}

	return database;
}


/*
 Match sequences in FID and output them
*/
void matchSeq()
{

}


/*
 Random access in FASTA file via indexed
 byte positions from database
*/
void printSeq(int[2][string] database, string fidName, string[] seqret, string outfilename)
{
	File fidx = File(fidName, "rb");
	//writeln("Printing sequences to stdout");
	foreach (string seq; seqret)
	{
		try
		{
			// Seek to start of current record (seq)
			fidx.seek(database[seq][0]);

			// Read and print database[seq][1] bytes
			char[] buffer = new char[](database[seq][1]);
			char[] buffer2 = fidx.rawRead(buffer);
			writeln(buffer2);
		}
		catch (Error e)
		{
			writeln("ERROR Key not in database: "~seq);
			//writeln(e);
		}
	}
}


/* Print helpful information */
void printHelp()
{
	writeln("usage: ris [options]... FILE SEQID...");
	writeln("Retrieve SEQID(s) from indexed fasta FILE.");
	writeln("Written in D programming language, Fredrik Boulund (c) 2012).");
	writeln("Available options:\n"
		"  -o, --output FILENAME	write output to filename instead of stdout\n"
		"  -r, --retrieve REGEXP	use REGEXP to retrieve matching records\n"
		"  -h, --help				Show this friendly and helpful message\n"
		);
}


int main(string[] args)
{
	// Init variables
	bool help;
	string fileOut = "";
	string searchReg = "";
	int[2][string] database;
	
	/* Parse command line options and arguments */
	if (args.length < 2)
	{
		printHelp();
		return 0;
	}
	else if ((args.length > 1) & (args.length < 3))
	{
		writeln("Need at least one sequence ID to retrieve!");
		printHelp();
	}
	try
	{
		getopt(args,
			"o", &fileOut,
			"output", &fileOut,
			"r", &searchReg,
			"retrieve", &searchReg,
			"h", &help,
			"help", &help);
		if (help)
		{
			printHelp();
			return 0;
		}
	}
	catch (Exception e)
	{
		writefln("%S\nType -h or --help for help", e.msg);
		return 1;
	}

	database = readFID(args[1]);

	printSeq(database, args[1][0..$-5],  args[2..$], fileOut);


	return 0;
}
