#!/usr/bin/perl
use strict;
use warnings;

#split_multi_fasta.pl
#Fasta file ARGV[0]

my $infile1 = $ARGV[0];
my @inname = split(/\//, $infile1);
open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";


my %fasta_id;

my $outhandle;
while (my $line = <$inhandle1>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	if (substr($line, 0,1) eq '>' ){  #header
	  my @list = split(/\>|" "/, $line);
	  my $filename = $list[1]."_".$inname[-1];
	  open $outhandle, '>', $filename or die ("Couldn't write to the file $outhandle");
	  print $outhandle $line, "\n";
			
	}else{ #body
		print $outhandle $line, "\n";
		
	}
}
