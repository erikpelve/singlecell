#!/usr/bin/perl
use strict;
use warnings;

#remove_fasta.pl
#Fasta file ARGV[0], list of fasta entries to exclude as ARGV[1]

my $infile1 = $ARGV[0];
my $infile2 = $ARGV[1];
my @outname = split(///, $infile1);
my $outfile1 = "renamed_".$inname[-1];

open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";
open my $inhandle2, '<', $infile2 or die "Couldn't open the file $infile2\n";
open my $outhandle1, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";

my %fasta_id;

#Read file of fasta names to exclude




while (my $line = <$inhandle>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	if (substr($line, 0,1) eq '>' ){
