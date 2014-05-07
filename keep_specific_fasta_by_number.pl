#!/usr/bin/perl
use strict;
use warnings;

#keep_fasta.pl
# ARGV [0] - number of fasta sequence in file to keep. 
#Fasta files ARGV[1] ...

#new file name = "gene.N.fasta"

#test if ARGV 0 is a number
if ($ARGV[0] =~ /^[+-]?\d+$/ ) {
    
} else {
    "ARGV[0] needs to be a number\n";
	exit;
}

my $outfile = "gene.".$ARGV[0].".fasta";
open my $outhandle, '>', $outfile or die "Couldn't write to the file $outfile\n";




my $n = 0;

foreach(@ARGV){
	$n++;
	next if $n = 1; #skip first attribute, where the number is stored.
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
			print $outhandle $line	
			}
			else{}
		}
		
	}
}

