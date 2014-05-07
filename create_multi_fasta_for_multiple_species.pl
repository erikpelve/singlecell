#!/usr/bin/perl
use strict;
use warnings;

#create_multi_fasta_for_multiple_species.pl
# ARGV [0] - list of fasta file names and fasta seq to keep
#Fasta files ARGV[1] ...



my $outfile = "gene.".$ARGV[0].".fasta";
open my $outhandle, '>', $outfile or die "Couldn't write to the file $outfile\n";




my $n = 0;

foreach(@ARGV){
	$n++;
	next if ($n == 1); #skip first attribute, where the number is stored.
	my $infile1 = $_;
	open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";

	my $m = 0;
	my $flag = 0;
	while (my $line = <$inhandle1>){
	chomp $line;
#	my @list = split(" ", $line);
		if (substr($line, 0,1) eq '>' ){
			$m++;
			$flag = 0;
			if ($m == $ARGV[0]){
				$flag = 1;
				print $outhandle $line, "\n";
			}else{}
		}else{
			if ($flag == 1){
			print $outhandle $line, "\n";	
			}
			else{}
		}
		
	}
}

