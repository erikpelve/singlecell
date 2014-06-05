#!/usr/bin/perl
use strict;
use warnings;

#concatinate_fasta_aligns2.pl
# ARGV [0] = prefix
# ARGV [1] ... - fasta aligns. Each file is a specific file. Every file have to contain genes from the same species, and the gene from each species have to have the same fasta handle in each file.

###Update
#V.2: 
#- Add prefix as ARGV[0]
#- Calculate the border coordinates of each gene, output file that can be used for RAXML -g input 

my $prefix = $ARGV[0];

my $outfile = $prefix.".concatinated.align.fasta";
open my $outhandle, '>', $outfile or die "Couldn't open the file $outfile\n";

my $outfile2 = "gene_index.".$prefix.".concatinated.align.fasta";
open my $outhandle_index, '>', $outfile2 or die "Couldn't open the file $outfile2\n";

my %gene_list; #filename and geneseq

#for each fasta file

my $index_position = 0;
my $n = 0;
foreach(@ARGV){
	$n++;
	next if($n == 1);
	

	my $infile1 = $_;

	my @infile_list = split(/\//, $infile1);
	my $infile_name = $infile_list[-1];
	my @infile_parts = split (/\./, $infile_name); 
	open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";


	my $gene_name;
	my @tempseq;

	my $index_position_plus1 = $index_position +1;

	# print index file
	print $outhandle_index "DNA, ", $infile_parts[0], " = ", $index_position_plus1 , "-"; # print the line for the coming gene, except the end coordinate


	#loop fasta file
	my $flag = 0;
	my $gene_no = 0;



	while (my $line = <$inhandle1>){
		chomp $line;
		if (substr($line, 0,1) eq '>' ){ #header
			if ($flag ==1){
				my $seq = join("\n",@tempseq);
				my $chompseq = $seq;
				chomp $chompseq;
				$index_position = $index_position + length($chompseq) if ($gene_no ==0);
				print $outhandle_index $index_position, "\n" if ($gene_no == 0);;
				$gene_no++;
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
					 $seqcul = $gene_list{$gene_name}."\n".$seq;
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
