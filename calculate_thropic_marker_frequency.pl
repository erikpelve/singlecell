#!/usr/bin/perl
use strict;
use warnings;

##calculate_thropic_marker_frequency.pl
##Erik Pelve, MIT, Mars 2014

##Script that takes webMGA output for multiple genomes as input. Compare with list of known COGs, calculate frequency for copiotrophic and oligotrophic markers.
##List of markers from: Lauro, F.M. et al., 2009. The genomic basis of trophic strategy in marine bacteria. Proceedings of the National Academy of Sciences of the United States of America, 106(37), pp.15527–33. Available at: http://www.pubmedcentral.nih.gov/articlerender.fcgi?artid=2739866&tool=pmcentrez&rendertype=abstract.
##WebMGA: http://weizhong-lab.ucsd.edu/metagenomic-analysis/server/cog/

##Input webMGA output.2 as ARGV[0]
##Input faa file as ARGV[1]

my $infile = $ARGV[0];
my $infile2 = $ARGV[1];
my @name_list = split(/\//, $infile);
my $inname = $name_list[-1];
my $outfile = "trophic_marker_frequency_".$inname.".txt";

open my $inhandle, '<', $infile or die "Couldn't read the file $infile\n";
open my $outhandle, '>', $outfile or die "Couldn't write to the file $outfile\n";
open my $inhandle2, '<', $infile2 or die "Couldn't read the file $infile\n";



#Thropic markers from Lauro_etal_2009
my %oligotroph_markers = ("COG0183", 1,
"COG0318", 1,
"COG1024", 1,
"COG1804", 1,
"COG1960", 1,
"COG1028", 1,
"COG0412", 1,
"COG1228", 1,
"COG0625", 1,
"COG0179", 1,
"COG1680", 1,
"COG3485", 1,
"COG2124", 1);
my %copiotroph_markers = ("COG1263", 1,
"COG1299", 1,
"COG0733", 1,
"COG0697", 1,
"COG1292", 1,
"COG2116", 1,
"COG2704", 1,
"COG0697", 1,
"COG0814", 1,
"COG1114", 1,
"COG1275", 1,
"COG1972", 1,
"COG2271", 1,
"COG3104", 1,
"COG3325", 1,
"COG0826", 1,
"COG0243", 1,
"COG0716", 1,
"COG2863", 1,
"COG3005", 1,
"COG0243", 1,
"COG0716", 1,
"COG3005", 1,
"COG0835", 1,
"COG0840", 1,
"COG0745", 1,
"COG2197", 1,
"COG3437", 1,
"COG0110", 1);

my %organism_oligotroph_number;
my %organism_copiotroph_number;
my %organism_gene_number;

# read file 2 - get organism name


my %org_name; ## key = protein id, name = organism name
my %organism_list; ##key = organism name, name = 1

while (my $line = <$inhandle2>){
	chomp $line;

	if (substr($line, 0,1) eq '>' ){  #only work with names from the fasta file




		#finding the organism name
		my @list = split(/\[/, $line);   #The name is last in the string, between []
		my @list2 = split(/\]/, $list[-1]);

		#finding the protein number
		my @list3 = split(/\|/, $line);

		$org_name{$list3[3]} = $list2[0];


		$organism_list{$org_name{$list3[3]}} = 1;

	}

	}



#Read file 1
while (my $line = <$inhandle>){
	chomp $line;
	my @list = split(/\t/, $line);
	my $organism_name;

	my @list2 = split(/\|/, $list[0]);
	my $protein_id = $list2[3];

	my $cog = $list[1];


	if (exists $org_name{$protein_id}){
		$organism_name = $org_name{$protein_id};
	}else{
		print "Warning - unidentified $protein_id: $protein_id\n";
		}



	if (exists $organism_gene_number{$organism_name}){
		$organism_gene_number{$organism_name}++;
		}else{
			$organism_gene_number{$organism_name} = 0;
		}




	if (exists $oligotroph_markers{$cog}){
		if (exists $organism_oligotroph_number{$organism_name}){
			$organism_oligotroph_number{$organism_name}++;
		}else{
			$organism_oligotroph_number{$organism_name} = 0;
		}
	}

	if (exists $copiotroph_markers{$cog}){
		if (exists $organism_copiotroph_number{$organism_name}){
			$organism_copiotroph_number{$organism_name}++;
		}else{
			$organism_copiotroph_number{$organism_name} = 0;
		}
	}


}


print $outhandle "Organism\tGene_no\tOligotrophic_markers_no\tCopiotrophic_markers_no\tOligotrophic_markers_%\tCopiotrophic_markers_%\n";

foreach my $organism_name (sort keys %organism_list){
	my $gene_no = $organism_gene_number{$organism_name};
	my $oligotroph_markers = $organism_oligotroph_number{$organism_name};
	my $copiotroph_markers = $organism_copiotroph_number{$organism_name};
	my $oligotroph_freq = 100 *($oligotroph_markers / $gene_no);
	my $copiotroph_freq = 100 * ($copiotroph_markers / $gene_no);

	print $outhandle "$organism_name\t";
	print $outhandle "$gene_no\t";
	print $outhandle "$oligotroph_markers\t";
	print $outhandle "$copiotroph_markers\t";
	print $outhandle "$oligotroph_freq\t";
	print $outhandle "$copiotroph_freq\n";
	}

print "Done! Output in the file $outfile";
