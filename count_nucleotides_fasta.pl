#!/usr/bin/perl
use strict;
use warnings;

# count_nucleotides_fasta.pl
#ARGV0 = multifasta file

my $infile1 = $ARGV[0];

open my $inhandle1, '<', $infile1 or die ("couldn't open the file $infile1");


my $s = 1; 
my $n = 0;

my %characters;
my $name;
while (my $line = <$inhandle1>){ #Loop through fasta file
	$line =~ s/\r|\n//g;
	chomp $line;

	if (substr($line, 0,1) eq '>' ){
		if ($s==0){
			print $n, "\t";
			foreach (sort keys %{$characters{$name}}){
				print $_, ": $characters{$name}{$_}\t"
				}
			$n =0;
			
			print "\n";
			
		}
		$name = $line;
		print $line, "\t";
		$s =0;
	}else{
		my @count = split("", $line);
		foreach(@count){
			$n++;
			if (exists $characters{$name}{$_}){
				$characters{$name}{$_} = $characters{$name}{$_} +1;
			
				}else{
					$characters{$name}{$_}= 1;
			
					}
				
			}
	
			}
}
