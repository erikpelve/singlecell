#!/usr/bin/perl
use strict;
use warnings;

#Remove problematic characters.
print "Remove problematic characters.\n\n";

my $infile = $ARGV[0];
my @namelist = split(/\//, $infile);
my $outfile1 = "formated_headers_".$namelist[-1];

open my $inhandle, '<', $infile or die "Couldn't open the file $infile\n";
open my $outhandle1, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";

while (my $line = <$inhandle>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	if (substr($line, 0,1) eq '>' ){
		$line =~s/\:|\`|\.|\,|\"|\'|\;|\:|\{|\}|\[|\]|\+|\ |\||\=|\-/_/g;
		$line =~s/\_+/_/g;		
	print $outhandle1 $line, "\n";

	}
	else{
		print $outhandle1 $line, "\n";
	
	}
}

print "Done. Outputs in file $outfile1 \n\n";
