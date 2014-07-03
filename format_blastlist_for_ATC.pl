#!/usr/bin/perl
use strict;
use warnings;

#format_blastlist_for_ATC.pl
#Input blast list (from the m8 flag, tab list on galaxy)file ARGV[0]
#ARGV[1] (optional) and query seq. absolute position file (0 or blank for not add)
#ARGV[2] (optional) and subject seq. absolute position file (0 or blank for not add)
#ARGV[4] (optional) score cutoff value. If empty or 0 - no cutoff

#Print the following separated by space
#12 bitscore Bit score
#3 pident Percentage of identical matches
#7 qstart Start of alignment in query
#8 qend End of alignment in query
#1 qseqid Query Seq-id (ID of your sequence)
#9 sstart Start of alignment in subject (database hit) 
#10 send End of alignment in subject (database hit)
#2 sseqid Subject Seq-id (ID of the database hit)





my $infile1 = $ARGV[0];
my $infile2 = $ARGV[1];
my $infile3 = $ARGV[2];
my $infile4 = $ARGV[3];

my @inname = split(/\//, $infile1);
my $outfile1 = "ACT_formated_comparison_file.".$inname[-1];

open my $inhandle1, '<', $infile1 or die "Couldn't open the file $infile1\n";

my %poslist_query; #gene #start #stop
my %poslist_subject;#gene #start #stop
my $flag_pos_query = 0;
my $flag_pos_subject = 0;

if (exists $ARGV[1]){
	if ($ARGV[1] eq "0"){
	}else{
	 $flag_pos_query = 1;
	open my $inhandle2, '<', $infile2 or die "Couldn't open the file $infile2\n";
	while (my $line = <$inhandle2>){
		chomp $line;
		my @list = split(/\t/, $line);		
		$poslist_query{$list[0]} = $list[1]."\t".$list[2];

	}
	}
}	
	
	
if (exists $ARGV[2]){
	if ($ARGV[2] eq "0"){}else{
	 $flag_pos_subject = 1;
	open my $inhandle3, '<', $infile3 or die "Couldn't open the file $infile3\n";
	while (my $line = <$inhandle3>){
		chomp $line;
		my @list = split(/\t/, $line);		
		$poslist_subject{$list[0]} = $list[1]."\t".$list[2];
	}}
}


my $scorecutoff = 0;

if (exists $ARGV[3]){
	if ($ARGV[3] eq "0"){
	}else{
		 $scorecutoff = $ARGV[3];
	}
}


open my $outhandle, '>', $outfile1 or die "Couldn't write to the file $outfile1\n";





#cycle file
while (my $line = <$inhandle1>){
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	my @list = split(/\t/, $line);
	my $qstart =$list[6];
	my $qstop = $list[7];
	my $sstart=$list[8];
	my $send=$list[9];

	#Filter on score
	if ($scorecutoff eq "0"){}else{
		next if ($list[11] < $scorecutoff);

	}


			#query
	if ($flag_pos_query == 1){
		if (exists $poslist_query{$list[0]}){
			my @pos_list = split(/\t/, $poslist_query{$list[0]});
			$qstart = $pos_list[0];
			$qstop = $pos_list[1];
		}
	else{print "Couldn't find $list[0]", "\n"}
		}
	#subject
	if ($flag_pos_subject == 1){
		my @pos_list = split(/\t/, $poslist_subject{$list[1]});
		#	print $poslist_subject{$list[1]}, "\n";
			print $list[1], "\n";
			$sstart = $pos_list[0];
			$send = $pos_list[1];
		}

	$list[11] =~ s/^\s*(.*?)\s*$/$1/;

	print $outhandle $list[11], " ", $list[2], " ",  $qstart , " ", $qstop, " ", $list[0], " ", $sstart, " ",$send, " ", $list[1], "\n";
	}
	
print "\nDone. Output file: $outfile1\n";

