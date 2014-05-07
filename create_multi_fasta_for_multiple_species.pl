#!/usr/bin/perl
use strict;
use warnings;

#create_multi_fasta_for_multiple_species.pl
# ARGV [0] - list of fasta file names and fasta seq to keep
#Fasta files ARGV[1] ...



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




#for each fasta file
my $n = 0;

foreach(@ARGV){
	$n++;
	next if ($n == 1); #skip first attribute, where the number is stored.
	my $infile1 = $_;
	my @infile_list = split(/\//, $infile1);
	my $infile_name = $infile_list[-1];
	open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";
	
	#skip files that are not on the list
	if (exists $gene_list{$infile_name}){
	}else{
	next;}

	my $gene_name = $gene_list{$infile_name};
	my $flag = 0;

	#loop fasta file
	while (my $line = <$inhandle1>){
		chomp $line; 
		if (substr($line, 0,1) eq '>' ){ #header
			$flag = 0;
			my @fasta_split =  split(/\>/, $line);
			my @fastanamelist = split(/\ /, $fasta_split[1]);
			my $fastaname = $fastanamelist[0];


	my @namelist = split(/\_/, $infile_list[-1]);
	my $m;
                        if (($n-1) <= 9){
                                $m = "00".($n-1);
                                }
                        elsif(($n-1) <= 99){
                                $m = "0".($n-1);
                                }
                        elsif(($n-1) <= 999){
                                $m = ($n-1);
                                }
                        elsif(($n-1) == 1000){
                                die "Warning, maximum 999 sequences can be processed.\n";
                                }

	my $newname = ">".substr($namelist[0], 0,1).substr($namelist[1],0,4).$m;


			if ($fastaname eq $gene_name){
							$flag = 1;
				print $outhandle $newname, "\n";
			}else{}
		}else{
			if ($flag == 1){
			print $outhandle $line, "\n";	
			}
			else{}
		}
		
	}
}

