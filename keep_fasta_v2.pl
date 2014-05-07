#!/usr/bin/perl
use strict;
use warnings;

#keep_fasta.pl
#Fasta file ARGV[0], list of fasta entries to include as ARGV[1]. Should not start with >
#splits fasta names that contain " ", only match first part, still prints whole part.

my $infile1 = $ARGV[0];
my $infile2 = $ARGV[1];
my @inname = split(/\//, $infile1);
my $outfile1 = "subset.".$inname[-1];

open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";
open my $inhandle2, '<', $infile2 or die "Couldn't open the file $infile2\n";
open my $outhandle, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";

my %fasta_id;

#Read file of fasta names to include
while (my $line = <$inhandle2>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	my @list = split(" ", $line);
	$fasta_id{$list[0]} = 1;
}


#Read fasta file, keep indicated fasta.	
my $flag = 0;	#flag = 1 means keep
while (my $line = <$inhandle1>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	if (substr($line, 0,1) eq '>' ){  #header
			$flag = 0;
			my @list = split(/\>| /, $line);
				if(exists $fasta_id{$list[1]}){
			  print $outhandle $line, "\n";
			  $flag = 1;
			}
	}else{
		if($flag == 1){
			print $outhandle $line, "\n";
		}
	}
	}
