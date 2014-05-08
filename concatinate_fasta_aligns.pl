#!/usr/bin/perl
use strict;
use warnings;

#concatinate_fasta_aligns.pl
# ARGV [0] ... - fasta aligns. Each file is a specific file. Every file have to contain genes from the same species, and the gene from each species have to have the same fasta handle in each file.


my %gene_list; #filename and geneseq

#for each fasta file

foreach(@ARGV){
	my $infile1 = $_;
	my @infile_list = split(/\//, $infile1);
	my $infile_name = $infile_list[-1];
	open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";

	
	my $gene_name;
	my @tempseq;
	#loop fasta file
	$flag = 0;
	while (my $line = <$inhandle1>){
		chomp $line;
		if (substr($line, 0,1) eq '>' ){ #header
			if ($flag ==1){
				my $seq = join("\n",@tempseq)
				my $seqcul = $gene_list{$gene_name}.$seq;
				$gene_list{$gene_name} = $seqcul;
				
				@tempseq = ();
				}
			$gene_name = $line;
		}else{
			$flag =1;
			push(@tempseq, $line);
			}
			
	}
		
	
}

foreach my $genome (sort keys %gene_list){
	print $genome, "\n", $gene_list{$genome}, "\n";
	}
