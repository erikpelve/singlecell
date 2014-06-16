#!/usr/bin/perl
use strict;
use warnings;


#add_suffix_number_fasta.pl
#adds an underscore and a number, starting with 1, to each fastafilename in the file.
#ARGV[0] = fasta file


my $infile1 = $ARGV[0];
my @inname = split(/\//, $infile1);
my $outfile1 = "suffix.".$inname[-1]; 

open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";
open my $outhandle, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";

my %fasta_id;


#Read fasta file, keep indicated fasta.	
my $number = 0;
while (my $line = <$inhandle1>){

	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	if (substr($line, 0,1) eq '>' ){  #header
		$number++;
			print $outhandle $line."_".$number, "\n";
		}
	
	else{
			print $outhandle $line, "\n";
		}
}

