#!/usr/bin/perl
use strict;
use warnings;

# count_nucleotides_fasta.pl
#ARGV0 = multifasta file

my $infile1 = $ARGV[0];

open my $inhandle1, '<', $infile1 or die ("couldn't open the file $infile1");






while (my $line = <$inhandle1>){ #Loop through fasta file
	$line =~ s/\r|\n//g;
	chomp $line;
	if (substr($line, 0,1) eq '>' ){
		print $line, "\t"
		


				}



}
