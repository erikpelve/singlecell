#!/usr/bin/perl
use strict;
use warnings;

#split_multi_fasta_and_split_contigs_in_pieces.pl
#Multi fasta file ARGV[0], bp size of pieces (default = 1000 bp) ARGV[1]. Contigs smaller than SIZE bp are left as they are.


my $infile1 = $ARGV[0];
my @inname = split(/\//, $infile1);
open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";

#bp size to cut contigs in
my $size = 1000;
$size = $ARGV[1] if (exists $ARGV[1]);



my %fasta_id;

my $outhandle;

my $contigsize;
my $within_contig_counter = 1;
my $flag = 0;
my $filename;
my $contig_name;

while (my $line = <$inhandle1>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	if (substr($line, 0,1) eq '>' ){  #header
	  $within_contig_counter = 1;
	  my @list = split(/\>|" "/, $line);
	  $filename = $list[1]."_".$inname[-1];
	  my $filename_final = $filename."_".$within_contig_counter;
	  open $outhandle, '>', $filename_final or die ("Couldn't write to the file $filename_final");
	  $contig_name = $line;
	  print $outhandle $contig_name."_".within_contig_counter, "\n";
	  
	}else{ #body
	my $old_contigsize = $contigsize;
	$contigsize = length($line) + $contigsize;
	if ($contigsize < $size){
		print $outhandle $line, "\n";
	}else{ #swith to new subcontig
		#finish old subcontig
		my $number_of_characters_to_print = $size - $old_contigsize;
		my $beginning_of_line = substr($line, 0, $number_of_characters_to_print, "");
		print $outhandle $beginning_of_line;
		
#		start new contig
		$within_contig_counter = $within_contig_counter +1 
		my $filename_final = $filename."_".$within_contig_counter;
		open $outhandle, '>', $filename_final or die ("Couldn't write to the file $filename_final");
		print $outhandle $contig_name."_".within_contig_counter, "\n";
		print $outhandle $line #what remains of the $line
		}
	

	}
}
