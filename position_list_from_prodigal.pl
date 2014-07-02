#!/usr/bin/perl
use strict;
use warnings;

#position_list_from_prodigal.pl
#create list of absolute positions of genes from prodigal fasta names
#very context dependent tool. Modify as needed
#Erik Pelve, June 2014
#Input progidal fasta file where there are space separated names of files .blast list (from the m8 flag, tab list on galaxy)file ARGV[0]

my $infile1 = $ARGV[0]; #Input 

my @inname = split(/\//, $infile1);
my $outfile1 = "Absolute_position_list.".$inname[-1];

open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";
open my $outhandle, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";


#cycle file
my $acc_pos = 0;
my $acc_contig_length = 0;
my $current_contig = 0;
while (my $line = <$inhandle1>){
	if (substr($line, 0,1) eq '>' ){  #header
		$line =~ s/\r|\n//g; #Remove newlines, regardless of format
		chomp $line;
		my @list = split(/ /, $line);
		my @list2 = split(/_/, $list[0]);
		my $gene_name = $list[0];
		my $contig = $list2[0]."_".$list2[1]."_".$list2[2]."_".$list2[3]."_".$list2[4]."_".$list2[5]."_".$list2[6]."_".$list2[7];
		my $contig_size = $list2[3];
		my $start = $list[2];
		my $end = $list[4];
		
		if ($current_contig eq "0"){ #skip for first round
			$current_contig = $contig;
			}else{
				if ($contig eq $current_contig){
				}else{
					$current_contig = $contig;
					$acc_pos = $acc_pos + $contig_size;	
					 $acc_contig_length =  $acc_contig_length + $contig_size;
#		print $outhandle $contig_size, "\n";
				}
		}
		
		my $acc_start = $acc_pos + $start;
		my $acc_end = $acc_pos + $end;		
		print $outhandle $gene_name, "\t", $acc_start, "\t", $acc_end, "\n";
		
		
#		print $outhandle $contig, "\t", $contig_size, "\t",  $acc_contig_length, "\t", $gene_name, "\t", $start, "\t", $end, "\t", $acc_start, "\t", $acc_end, "\n";
		
	
	
	}else{
	}
	}
	
print "\nDone. Output file: $outfile1\n";

