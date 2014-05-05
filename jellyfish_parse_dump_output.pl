#!/usr/bin/perl
use strict;
use warnings;

#jellyfish_parse_dump_output.pl
#Fasta files from the jellyfish dump command ARGV[0] - ...

foreach(@ARGV){
  }
my $infile = $ARGV[0];
my @inname = split(/\//, $infile1);
open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";
