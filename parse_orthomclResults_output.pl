#!/usr/bin/perl
use strict;
use warnings;

#parse_orthomclResults_output.pl
# input - ARGV0 - ARGV... included datasets, orthologGroups -files


my $n = 0;
my @infile;
my @inhandle;
#outfiles
my $outfile1 = "compare_OrthoMCL_info.txt";
my $outfile2 = "compare_OrthoMCL_shared_OrthoMCL.txt";
my $outfile3 = "compare_OrthoMCL_not_shared_OrthoMCL.txt";
my $outfile4 = "compare_OrthoMCL_unique_OrthoMCL.txt";
my $outfile5 = "compare_OrthoMCL_shared_OrthoMCL_summary.txt";
my $outfile6 = "compare_OrthoMCL_all_OrthoMCL.txt";
my $outfile7 = "compare_OrthoMCL_not_shared_OrthoMCL_summary.txt";
my $outfile8 = "compare_OrthoMCL_unique_OrthoMCL_whole_orthologGroups_entry.txt";

open my $outhandle1, ">", $outfile1 or die ("Coultn't write to the file $outfile1");
open my $outhandle2, ">", $outfile2 or die ("Coultn't write to the file $outfile2");
open my $outhandle3, ">", $outfile3 or die ("Coultn't write to the file $outfile3");
open my $outhandle4, ">", $outfile4 or die ("Coultn't write to the file $outfile4");
open my $outhandle5, ">", $outfile5 or die ("Coultn't write to the file $outfile5");
open my $outhandle6, ">", $outfile6 or die ("Coultn't write to the file $outfile6");
open my $outhandle7, ">", $outfile7 or die ("Coultn't write to the file $outfile7");
open my $outhandle8, ">", $outfile8 or die ("Coultn't write to the file $outfile8");


print $outhandle1 "parse_orthomclResults_output.pl\n";
print $outhandle1 scalar localtime();
print $outhandle1 "\n\nOutput files:\n$outfile1\n$outfile2\n$outfile3\n$outfile4\n$outfile5\n$outfile6\n$outfile7\n$outfile8\n\nInput files:\n";



#Open infiles
foreach(@ARGV){
	 $infile[$n] = $ARGV[$n];
	 open $inhandle[$n], "<", $infile[$n] or die ("couldn't open the file $infile[$n]\n");
	print $outhandle1 $infile[$n], "\n";
		$n++;

}

print $outhandle1 "\n\nGenome\tNumber_of_OrthoMCLs\n";

my %all_OrthoMCL; #One hash with all OrthoMCL
my %genomes; #hash in hash {genome}{file name (inkl. search path} = OrthoMCL

print $outhandle5 "\t"; # summary file
print $outhandle7 "\t"; # summary file

# Read files, store OrthoMCL in hashes
foreach  (0..($n-1)){
	print $outhandle5  $infile[$_], "\t";  # summary file summary file
	print $outhandle7  $infile[$_], "\t";  # summary file summary file
	my $total_counter = 0;
	while(my $line = readline($inhandle[$_])){
		chomp $line;
		my @list = split(/\t/, $line);
		my $OrthoMCL = $list[1];
		#Add OrthoMCL to common list
		if (exists $all_OrthoMCL{$OrthoMCL}){
		}else{
			$all_OrthoMCL{$OrthoMCL} = 1;
		} 
#		#Add OrthoMCL to specific list
		if (exists $genomes{$infile[$_]}{$OrthoMCL}){
			
		}else{
			$genomes{$infile[$_]}{$OrthoMCL} = 1; 
			print $outhandle6 $infile[$_], "\t", $OrthoMCL, "\n";
			$total_counter++;
		}
	}
	print $outhandle1 $infile[$_], "\t", $total_counter, "\n";
}
print $outhandle5 "\n";# summary file
print $outhandle7 "\n";# summary file

print $outhandle1 "\n\nGenome\tNumber_of_Unique_OrthoMCLs\n";

#print $outhandle5 "Genome1\tGenome2\tShared_OrthoMCLs\tNot_shared_OrthoMCLs\n";

#Compare hashes
foreach my $genome (sort keys %genomes){
		print $outhandle5  $genome, "\t"; # summary file
		print $outhandle7  $genome, "\t"; # summary file
		foreach (0..($n-1)){ #Loop through all genomes
			if ($infile[$_] eq $genome){
			print $outhandle5  "\t"; # summary file
			print $outhandle7  "\t"; # summary file
			next;
			} # to not run a file vs itself
			my $shared_counter = 0;
			my $not_shared_counter = 0;
			my $genome_vs_genome = $genome."\t".$infile[$_];
			foreach my $OrthoMCL (sort keys %{ $genomes{$genome} }){
					 if ($OrthoMCL eq "NO_GROUP"){
					 	$genomes{$genome}{$OrthoMCL} = 0; #Flag not unique
					 	next;
					 }
					#IF shared
						if (exists $genomes{$infile[$_]}{$OrthoMCL}){
							print $outhandle2 $genome_vs_genome, "\t", $OrthoMCL, "\n";
							$genomes{$genome}{$OrthoMCL} = 0; #Flag not unique
							$shared_counter++;
					}else{#IF not shared
						print $outhandle3 $genome_vs_genome, "\t", $OrthoMCL, "\n";
						$not_shared_counter++;
					}
			}	
		#	print $outhandle5 $genome_vs_genome, "\t", $shared_counter, "\t", $not_shared_counter, "\n";
			print $outhandle5  $shared_counter, "\t"; # summary file
			print $outhandle7  $not_shared_counter, "\t"; # summary file
		}	
	print $outhandle5  "\n";# summary file
	print $outhandle7  "\n";# summary file
	#IF not shared with any other genome
		my $unique_counter = 0;
		foreach my $OrthoMCL (sort keys %{ $genomes{$genome} }){
			next if ($OrthoMCL eq "NO_GROUP");
			if ($genomes{$genome}{$OrthoMCL} == 1){
					print $outhandle4 $genome, "\t", $OrthoMCL,"\n";
					$unique_counter++;
			}
			
		}
		print $outhandle1 $genome, "\t", $unique_counter, "\n";
}


#Close and reopen infiles

foreach(0..($n-1)){
	 close $inhandle[$_];
	 open $inhandle[$_], "<", $infile[$_] or die ("couldn't open the file $infile[$_]\n");
	 	}

# Read files again, print info for unique OrthoMCLs
foreach  (0..($n-1)){
	my $genome = $infile[$_];
	while(my $line = readline($inhandle[$_])){
		chomp $line;
		my @list = split(/\t/, $line);
		my $OrthoMCL = $list[1];
		if ($genomes{$genome}{$OrthoMCL} == 1){ #flagged unique
			print $outhandle8 $genome, "\t", $line, "\n";
			}
	}
}

print $outhandle1 "\n\nDone\n";
print "\n\nDone\n";
