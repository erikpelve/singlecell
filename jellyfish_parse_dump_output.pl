#!/usr/bin/perl
use strict;
use warnings;

#jellyfish_parse_dump_output.pl
#Fasta files from the jellyfish dump command ARGV[0] - ...
#Erik Pelve May 2014


my $outfile = "output.jellyfish.dump.table";
open my $outhandle, ">", $outfile or die "Couldn't write to the file $outfile\n";
#print $outhandle "\t";

my %contigs;
my %kmers;


#Cycle each input fasta file
foreach(@ARGV){
  open my $inhandle, '<', $_ or die "Couldn't open the file $_\n";
 # print $outhandle $_, "\n";
        my $freq;
      my $kmer;
  
  
  #Store data in hash

      while (my $line = <$inhandle>){
      
       chomp $line;
       if (substr($line, 0,1) eq '>' ){  #header
        my @list = split(/>/, $line);
         $freq = $list[1];
      	        }else{
        $kmer = $line;  
        $contigs{$_}{$kmer} = $freq;

        #Hash of all kmers
        if (exists $kmers{$line}){
          }else{
            $kmers{$line} = 1;
            }       
       }
 
    }


  }



#print headline
print $outhandle "\t"; 
foreach my $contig (sort keys %contigs){
   print $outhandle $contig, "\t";
}
  print $outhandle "\n"; 


#print kmer frequency
foreach my $kmer (sort keys %kmers){
  print $outhandle $kmer, "\t";
 foreach my $contig (sort keys %contigs){
	    if (exists $contigs{$contig}{$kmer}){
		    print $outhandle $contigs{$contig}{$kmer}, "\t";
         }else{
          print $outhandle "0", "\t";
          }
 
  }
     print $outhandle "\n" 
}



print "Done! Output in the file $outfile\n\n";


