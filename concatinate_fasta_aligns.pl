#!/usr/bin/perl
use strict;
use warnings;

#concatinate_fasta_aligns.pl
# ARGV [0] ... - fasta aligns. Each file is a specific file. Every file have to contain genes from the same species, and the gene from each species have to have the same fasta handle in each file.



my $outfile = $ARGV[0].".fasta";
open my $outhandle, '>', $outfile or die "Couldn't write to the file $outfile\n";


#Loop first file, store fasta file names and genes
my $infile_list = $ARGV[0];
open my $inhandle_list, '<', $infile_list or die "Couldn't open the file $infile_list\n";

my %gene_list; #filename and gene

while(my $line = <$inhandle_list>){
	chomp $line;	
	my @list = split(/\t/, $line);
	$gene_list{$list[0]} = $list[1];
	}


