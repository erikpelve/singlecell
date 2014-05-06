#!/usr/bin/perl
use strict;
use warnings;

#format_fasta_files_for_jellyfish_sh.pl
#ARGV[0] - list of fasta files with search path
#ARGV[1] - name of organism (for file-name, no spaces)

my $infile1 = $ARGV[0];
my @inname = split(/\//, $infile1);
open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";

my $outfile1 = "jellyfish.count.".$ARGV[1].".sh";
my $outfile2 = "jellyfish.dump.".$ARGV[1].".sh";
open my $outhandle1, '>', $outfile1 or die "Couldn't open the file $outfile1\n";
open my $outhandle2, '>', $outfile2 or die "Couldn't open the file $outfile2\n";


while (my $line = <$inhandle1>){
	chomp $line;
    my @list = split(/\//, $line);
    print $outhandle1 "jellyfish count -m 4 -s 100M -t 10 -o ".$ARGV[1]."_".$list[-1].".mer_counts.jf -C "."$line\n";
    print $outhandle2 "jellyfish dump ".$ARGV[1]."_".$list[-1].".mer_counts.jf > ".$ARGV[1]."_processed/ ".$ARGV[1]."_".$list[-1].".fasta\n";
}
