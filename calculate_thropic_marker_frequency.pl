#!/usr/bin/perl
use strict;
use warnings;

##calculate_thropic_marker_frequency.pl
##Erik Pelve, MIT, Mars 2014

##Script that takes webMGA output for multiple genomes as input. Compare with list of known COGs, calculate frequency for copiotrophic and oligotrophic markers.
##List of markers from: Lauro, F.M. et al., 2009. The genomic basis of trophic strategy in marine bacteria. Proceedings of the National Academy of Sciences of the United States of America, 106(37), pp.15527–33. Available at: http://www.pubmedcentral.nih.gov/articlerender.fcgi?artid=2739866&tool=pmcentrez&rendertype=abstract.
##WebMGA: http://weizhong-lab.ucsd.edu/metagenomic-analysis/server/cog/

##Input webMGA data as ARGV[0]

my $infile = $ARGV[0];
my @name_list = split(/\//, $infile);
my $inname = $name_list[-1];
my $outfile = "trophic_marker_frequency_".$inname.".txt";

open my $inhandle, '<', $infile or die "Couldn't read the file $infile\n";
open my $outhandle, '>', $outfile or die "Couldn't write to the file $outfile\n";


#Thropic markers from Lauro_etal_2009
@oligotroph_markers = ();
@copiotroph_markers = ();


#Read file
while (my $line = <$inhandle>){
	chomp $line;
    my @list = split(/\t/, $line);


}
