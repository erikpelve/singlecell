#!/usr/bin/perl
use strict;
use warnings;

#concatinate_fasta_aligns2.pl
# ARGV [0] ... - fasta aligns. Each file is a specific file. Every file have to contain genes from the same species, and the gene from each species have to have the same fasta handle in each file.

###Update
#V.2: Calculate the border coordinates of each gene, output file that can be used for RAXML -g input 

my $outfile = "concatinated.align.fasta";
open my $outhandle, '>', $outfile or die "Couldn't open the file $outfile\n";


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
	my $flag = 0;
	while (my $line = <$inhandle1>){
		chomp $line;
		if (substr($line, 0,1) eq '>' ){ #header
			if ($flag ==1){
				my $seq = join("\n",@tempseq);
				my $seqcul;
				if (exists $gene_list{$gene_name}){
					 $seqcul = $gene_list{$gene_name}.$seq;
					 }else{
					 $seqcul = $seq;
					 }
				$gene_list{$gene_name} = $seqcul;

				@tempseq = ();
				}
			$gene_name = $line;
		}else{
			$flag =1;
			push(@tempseq, $line);
			}

	}
	if ($flag ==1){
				my $seq = join("\n",@tempseq);
				my $seqcul;
				if (exists $gene_list{$gene_name}){
					 $seqcul = $gene_list{$gene_name}.$seq;
					 }else{
					 $seqcul = $seq;
					 }
				$gene_list{$gene_name} = $seqcul;

				@tempseq = ();
				$flag = 0;
				}


}

foreach my $genome (sort keys %gene_list){
	print $outhandle $genome, "\n", $gene_list{$genome}, "\n";
	}
