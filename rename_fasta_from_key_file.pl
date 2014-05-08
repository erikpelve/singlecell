#!/usr/bin/perl
use strict;
use warnings;

#rename_fasta_from_key_file.pl
#Prepare a fasta file for alignment.  I
# Inputs a ARGV0 multiple fasta file and a ARGV[1] key file, outputs a multiple fasta file with the names cropped to key.
#Key file: first column key, second column full name. Include >


my $infile1 = $ARGV[0];
my $infile2 = $ARGV[1];
my $outfile1 = "renamed_".$infile;

open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";
open my $inhandle2, '<', $infile2 or die "Couldn't open the file $infile2\n";
open my $outhandle1, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";

#read key
my %key; #{full name} = key
while(my $line = <$inhandle1>){
	chomp $line;
	my @list = split(/\t/, $line);
	$key{$list[1]} = $list[0]; 
}



while (my $line = <$inhandle>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	my $flag = 0;
	if (substr($line, 0,1) eq '>' ){
		if (exists $key{$line}){
			print $outhandle1 $key{$line}, "\n";
			}
	else{
		print $outhandle1 $line, "\n";
	
	}
}

print "Done. Output in file $outfile1\n\n";
