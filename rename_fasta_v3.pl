#!/usr/bin/perl
use strict;
use warnings;

#Prepare a fasta file for alignment. Crops names and remove sequences with exactly identical names. Inputs a multiple fasta file, outputs a multiple fasta file with the names cropped to 5 characters + _n where n is the number of occurrence of the sequence in the file (1,2,3...), resulting in unique sequence names. It also outputs a key-file with the original name and the new name.
print "Prepare a fasta file for alignment. Crops names and remove sequences with exactly identical names. Inputs a multiple fasta file, outputs a multiple fasta file with the names cropped to 5 characters + _n where n is the number of occurrence of the sequence in the file (1,2,3...), resulting in unique sequence names. It also outputs a key-file with the original name and the new name.\n\n";

my $infile = $ARGV[0];
my $outfile1 = "renamed_".$infile;
my $outfile2 = "key.renamed_".$infile;

open my $inhandle, '<', $infile or die "Couldn't open the file $infile\n";
open my $outhandle1, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";
open my $outhandle2, '>', $outfile2 or die "Couldn't write to the file $outfile2\n";

my %fasta_id;
my %fasta_newid;
my $flag = 0; #Flag 1 for duplicate sequence
my $n = 0;

while (my $line = <$inhandle>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	if (substr($line, 0,1) eq '>' ){
		if (exists $fasta_id{$line}){
			$flag = 1;
			print "Duplicate: $line\n";
			next;
		}
		else{
			$flag = 0;	
			$n++;
			my $m;
			if ($n <= 9){
				$m = "00".$n;
				}
			elsif($n <= 99){
				$m = "0".$n;
				}
			elsif($n <= 999){
				$m = $n;
				}
			elsif($n == 1000){
				die "Warning, maximum 999 sequences can be processed.\n";
				}
						

			my $newname = substr($line, 1, 5)."_$m";
			$fasta_id{$line} = $newname;	
			if(exists $fasta_newid{$newname}){
				print "Warning - duplicate IDs. That shouldn't be possible. Check the script.";
			}
			else{
			$fasta_newid{$newname} = 1;
				}
			# look for "|"
			my @testlist = split(/\|/, $newname);
			if (exists $testlist[1]){
			  $newname =~s/\|/\_/g;  
			  }
			
			print $outhandle1 ">".$newname, "\n";
			print $outhandle2 ">".$newname, "\t", $line, "\n";
		}
	}
	else{
		next if $flag == 1;
		print $outhandle1 $line, "\n";
	
	}
}

print "Done. Outputs in file $outfile1 and $outfile2\n\n";
