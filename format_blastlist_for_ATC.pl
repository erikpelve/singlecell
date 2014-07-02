#!/usr/bin/perl
use strict;
use warnings;

#format_blastlist_for_ATC.pl
#Input blast list (from the m8 flag, tab list on galaxy)file ARGV[0]

my $infile1 = $ARGV[0];

my @inname = split(/\//, $infile1);
my $outfile1 = "ACT_formated_comparison_file.".$inname[-1];

open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";
open my $outhandle, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";

#Print the following separated by space
#12 bitscore Bit score
#3 pident Percentage of identical matches
#7 qstart Start of alignment in query
#8 qend End of alignment in query
#1 qseqid Query Seq-id (ID of your sequence)
#9 sstart Start of alignment in subject (database hit) 
#10 send End of alignment in subject (database hit)
#2 sseqid Subject Seq-id (ID of the database hit)

#cycle file
while (my $line = <$inhandle1>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	my @list = split(/\t/, $line);
	print $outhandle $list[11], " ", $list[2], " ",  $list[6], " ", $list[7], " ", $list[0], " ", $list[8], " ", $list[9], " ", $list[1], "\n";
	}
	
print "\nDone. Output file: $outfile1\n";

