#!/usr/bin/perl
use strict;
use warnings;

print "Translate truncated species names to full names in RAxML output. Takes as input key-file with key in first column and full name in second (generated by the script rename_fasta_v2.pl) as ARGV[0], and the RAxML tree file as ARGV[1]\nARGV[2] is level of NCBI nomenclature to display (1 = Domain, default = last) \n\n\n";
##Example of NCBI taxonomy - Bacteria;Proteobacteria;Gammaproteobacteria;Alteromonadales;Alteromonadaceae;Alteromonas;Alteromonas macleodii




my $infile_key = $ARGV[0];
die ("No key in ARGV[0]") if ($ARGV[0] eq "");
my $infile_tree = $ARGV[1];
die ("No tree in ARGV[1]") if ($ARGV[1] eq "");
my $level = -1;
$level = $ARGV[2] if exists ($ARGV[2]);



open my $inhandle_key, '<', $infile_key or die ("Couldn't open the file $infile_key");
open my $inhandle_tree, '<', $infile_tree or die ("Couldn't open the file $infile_tree");

my %key_name;

while (my $line = <$inhandle_key>){
	chomp $line;
	my @list = split(/\t/, $line);
	die ("Problem with the key file. Did you add the files in the right order? First key, then tree.") if ($list[1] eq "");
	my $newname;
	my @id = split(/>|\.|;/, $list[1]);	
	my @name_list = split(/;/, $list[1]);
		if (exists $name_list[1]){
			my @id_cell3 = split(/ /, $id[3]);
			$newname = join("_", $id[$level], $id[1], $id[2], $id_cell3[0]);
			$newname =~s/ /_/g;
			}
		else{
		$newname = $id[1];
			}
	my @key_id = split(/>/, $list[0]);	
	$key_name{$key_id[1]} = $newname;
	}

my $outfile_tree = $infile_tree.".changed_names.txt";
open my $outhandle_tree, '>', $outfile_tree or die ("Couldn't write to the file $outfile_tree");


my $s = 0;
while (my $line = <$inhandle_tree>){
	chomp $line;
	foreach my $key (sort keys %key_name){
		$line =~s/$key/$key_name{$key}/g;
		print "$key\t$key_name{$key}\n" if ($s==0);
	}
	$s=1;
		print $outhandle_tree $line, "\n";
}

print "Done.\n\n";
