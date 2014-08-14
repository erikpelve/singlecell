#1.3 - change the basic approach - start with paired RBH rather than single genes.
#1.4 - change order. Assign pairs and triplets in different loops

#!/usr/bin/perl
use strict;
use warnings;

#R module - use only if I manage to get Cpan working on this computer
#use Statistics::R; #allow use of R script
#my $R = Statistics::R->new();
#$R->startR ;
#my $r_filename = "venn.r";

#RBH_make_venn_diagram_v1.0.pl

my $outfilesuffix = ".RBH.out.txt";

#Inflags. If default value is NULL - no default value is used.
my %inflag = ("a" , "NULL", #RBH file1
			"b" , "NULL", #RBH file2
			"c" , "NULL", #RBH file3
           "d",    "NULL", #genenames1 
            "e",    "NULL", #genenames1
            "f",    "NULL", #genenames1
           "o" ,    "$outfilesuffix", #output
            "r",	"y" #run R script - yes/n
            );
            
            
        
my $helpfile = "\n"."RBH_make_venn_diagram_v1.0.pl"."\n".
"-a,b,c"."\t"." three tab separated RBH files, output from the script compare_blasthits_for_RBH_v1.1.pl.  Default = $inflag{a}"."\n".
"-d,e,f"."\t"."three tab separated files with list of genenames. Default = $inflag{f}"."\n".
"-o"."\t"."output prefix. Default: $outfilesuffix"."\n".
"-r"."\t"."Run R script? y/n. Default: y"."\n".
"Note: Filennames of the files with genenames (d,e,f) are used for strain names (truncated by .)"."\n".
"Note: Be sure to pair the files in the following way: -a = -d vs -e ;; -b = -d vs -f ;; -c = -e vs -f"."\n".
"Note: This code is a bit of a patchwork. If you edit it, note that there are many fossile remains of failed attempts in here.\n".
"Erik Pelve, August 2014"."\n\n";

print $helpfile;

#Save flags
save_flags(@ARGV);

#Check Rflag
if ($inflag{r} eq "y" || $inflag{r} eq "n"){
	}else{
	die("flag r must be y or n\n");
}


#infiles

my $RBHfile1 = $inflag{a};
my $RBHfile2 = $inflag{b};
my $RBHfile3 = $inflag{c};
my $genefile1 = $inflag{d};
my $genefile2 = $inflag{e};
my $genefile3 = $inflag{f};

open my $genehandle1, '<', $genefile1 or die ("couldn't open the file $genefile1");
open my $genehandle2, '<', $genefile2 or die ("couldn't open the file $genefile2");
open my $genehandle3, '<', $genefile3 or die ("couldn't open the file $genefile3");
open my $RBHhandle1, '<', $RBHfile1 or die ("couldn't open the file $RBHfile1");
open my $RBHhandle2, '<', $RBHfile2 or die ("couldn't open the file $RBHfile2");
open my $RBHhandle3, '<', $RBHfile3 or die ("couldn't open the file $RBHfile3");


#find strainnames - first part of genefilename (truncated by .)
my @filelist1 = split(/\//, $genefile1);
my @filelist2 = split(/\//, $genefile2);
my @filelist3 = split(/\//, $genefile3);

my @namelist1 = split(/\./, $filelist1[-1]);
my @namelist2 = split(/\./, $filelist2[-1]);
my @namelist3 = split(/\./, $filelist3[-1]);

my $strain1 = $namelist1[0];
my $strain2 = $namelist2[0];
my $strain3 = $namelist3[0];

#outfile
my $outfile = "RBH.".$strain1.".".$strain2.".".$strain3.$outfilesuffix;
open my $outhandle, '>', $outfile or die ("Couldn't open the file outfile\n");

my %gene_uid; #all genes = uid
my %uid_gene_strain1; #uid = gene for this specific strain
my %uid_gene_strain2;
my %uid_gene_strain3;
my $UID =0;


my %all_genes;

my %RBH_strain1_vs_strain2;
my %RBH_strain2_vs_strain1;
my %RBH_strain1_vs_strain3;
my %RBH_strain3_vs_strain1;
my %RBH_strain2_vs_strain3;
my %RBH_strain3_vs_strain2;



#Read RBH files, store in hash
while (my $line = <$RBHhandle1>){
	my @list = array_from_tab($line);
	$RBH_strain1_vs_strain2{$strain1.".".$list[0]}=$strain2.".".$list[1];
	$RBH_strain2_vs_strain1{$strain2.".".$list[1]}=$strain1.".".$list[0];
}

while (my $line = <$RBHhandle2>){
	my @list = array_from_tab($line);
	$RBH_strain1_vs_strain3{$strain1.".".$list[0]}=$strain3.".".$list[1];
	$RBH_strain3_vs_strain1{$strain3.".".$list[1]}=$strain1.".".$list[0];

}

while (my $line = <$RBHhandle3>){
	my @list = array_from_tab($line);
	$RBH_strain2_vs_strain3{$strain2.".".$list[0]}=$strain3.".".$list[1];
	$RBH_strain3_vs_strain2{$strain3.".".$list[1]}=$strain2.".".$list[0];


}

my $number_of_genes_s1 = 0;
my $number_of_genes_s2 = 0;
my $number_of_genes_s3 = 0;

#Store all genenames in hash.
while (my $line = <$genehandle1>){
	chomp $line;
	$all_genes{$strain1.".".substr($line, 1)} = 0;
	$number_of_genes_s1++;
	}
while (my $line = <$genehandle2>){
	chomp $line;
	$all_genes{$strain2.".".substr($line, 1)} = 0;
	$number_of_genes_s2++;
	}
while (my $line = <$genehandle3>){
	chomp $line;
	$all_genes{$strain3.".".substr($line, 1)} = 0;
	$number_of_genes_s3++;
	}

#Output files
my $outfile1 = $strain1.".uid.txt";
my $outfile2 = $strain2.".uid.txt";
my $outfile3 = $strain3.".uid.txt";
my $outfile_log = "log.".$strain1.".".$strain2.".".$strain3.$outfilesuffix;
my $outfile_all = "shared_between_all_strains.".$strain1.".".$strain2.".".$strain3.$outfilesuffix;

open my $outhandle1, '>', $outfile1 or die("Couldn't write to the file $outfile1\n");
open my $outhandle2, '>', $outfile2 or die("Couldn't write to the file $outfile2\n");
open my $outhandle3, '>', $outfile3 or die("Couldn't write to the file $outfile3\n");
open my $outhandle_log, '>', $outfile_log or die ("Couldn't write to the file $outfile_log\n");
open my $outhandle_all, '>', $outfile_all or die ("Couldn't write to the file $outfile_all\n");


my %finished_genes; # hash with all genes already added for triplets
my %finished_genes_all; # hash with all genes already added
my %shared_between_all; # all genes and UIDs that are shared between all three strains


#########TRIPLETS##########

#Cycle through RBH files V1.3
##RBH file 1
foreach my $gene_s1 (sort keys %RBH_strain1_vs_strain2){
	my $gene_s2 = $RBH_strain1_vs_strain2{$gene_s1};
	
	
	next if (exists $finished_genes{$gene_s1});

	#identify S3 genes
	my $gene_s3_by_s1 = "NULL1";
	my $gene_s3_by_s2 = "NULL2";	
	$gene_s3_by_s1 = $RBH_strain1_vs_strain3{$gene_s1} if (exists  $RBH_strain1_vs_strain3{$gene_s1});
	$gene_s3_by_s2 = $RBH_strain2_vs_strain3{$gene_s2} if (exists $RBH_strain2_vs_strain3{$gene_s2});

	if ($gene_s3_by_s1 eq $gene_s3_by_s2){
		#UID for true tripple-shared gene
		$gene_uid{$gene_s1} = $UID;
		$gene_uid{$gene_s2} = $UID;
		$gene_uid{$gene_s3_by_s1} = $UID;
		$uid_gene_strain1{$UID} = $gene_s1;	
		$uid_gene_strain2{$UID} = $gene_s2;
		$uid_gene_strain3{$UID} = $gene_s3_by_s1;			
		$finished_genes{$gene_s3_by_s1} = 1;
		$finished_genes_all{$gene_s3_by_s1} = 1;
		$finished_genes{$gene_s1} = 1;
		$finished_genes{$gene_s2} = 1;
		
		$shared_between_all{$gene_s1} = $UID;
		$shared_between_all{$gene_s2} = $UID;
		$shared_between_all{$gene_s3_by_s1} = $UID;
		$UID++;
				 }

	$finished_genes_all{$gene_s1} = 1;
	$finished_genes_all{$gene_s2} = 1;

}



##RBH file 2
foreach my $gene_s1 (sort keys %RBH_strain1_vs_strain3){
	my $gene_s3 = $RBH_strain1_vs_strain3{$gene_s1};

	next if (exists $finished_genes{$gene_s1});

	#identify S2 genes
	my $gene_s2_by_s1 = "NULL1";
	my $gene_s2_by_s3 = "NULL2";	
	$gene_s2_by_s1 = $RBH_strain1_vs_strain2{$gene_s1} if (exists  $RBH_strain1_vs_strain2{$gene_s1});
	$gene_s2_by_s3 = $RBH_strain3_vs_strain2{$gene_s3} if (exists $RBH_strain3_vs_strain2{$gene_s3});
	
	if ($gene_s2_by_s1 eq $gene_s2_by_s3){
		print "2 True RBH: $gene_s1\t$gene_s3\t$gene_s2_by_s1\n"; #This comment should not be shown - consider it a warning.
		#UID True gene - assign UID
		$gene_uid{$gene_s1} = $UID;
		$gene_uid{$gene_s3} = $UID;
		$gene_uid{$gene_s2_by_s1} = $UID;
		$uid_gene_strain1{$UID} = $gene_s1;	
		$uid_gene_strain2{$UID} = $gene_s2_by_s1;
		$uid_gene_strain3{$UID} = $gene_s3;			
		$shared_between_all{$gene_s1} = $UID;
		$shared_between_all{$gene_s2_by_s1} = $UID;
		$shared_between_all{$gene_s3} = $UID;
		$UID++;
		$finished_genes{$gene_s2_by_s1} = 1;
		$finished_genes_all{$gene_s2_by_s1} =1; 
		$finished_genes{$gene_s1} = 1;
		$finished_genes{$gene_s3} = 1;
		 }else{
			#assign_UID_to_pair
			
			if (exists $gene_uid{$gene_s1}){
	#			print "Warning: Overwerite gene $gene_s1\n";
	#			$gene_uid{$gene_s1} = $UID;##
	#	$uid_gene_strain1{$UID} = $gene_s1;
				}
			}
	$finished_genes_all{$gene_s1} = 1;
$finished_genes_all{$gene_s3} = 1;

}




##RBH file 3
foreach my $gene_s2 (sort keys %RBH_strain2_vs_strain3){
	my $gene_s3 = $RBH_strain2_vs_strain3{$gene_s2};

next if (exists $finished_genes{$gene_s2});

	#identify S1 genes
	
	my $gene_s1_by_s2 = "NULL1";
	my $gene_s1_by_s3 = "NULL2";	
	$gene_s1_by_s2 = $RBH_strain2_vs_strain1{$gene_s2} if (exists  $RBH_strain2_vs_strain1{$gene_s2});
	$gene_s1_by_s3 = $RBH_strain3_vs_strain1{$gene_s3} if (exists $RBH_strain3_vs_strain1{$gene_s3});
	if ($gene_s1_by_s2 eq $gene_s1_by_s3){
		print "3 True RBH: $gene_s2\t$gene_s3\t$gene_s1_by_s3\n";  #This comment should not be shown - consider it a warning.
		$gene_uid{$gene_s2} = $UID;
		$gene_uid{$gene_s3} = $UID;
		$gene_uid{$gene_s1_by_s2} = $UID;
		$uid_gene_strain1{$UID} = $gene_s1_by_s2;	
		$uid_gene_strain2{$UID} = $gene_s2;
		$uid_gene_strain3{$UID} = $gene_s3;			

		$finished_genes{$gene_s1_by_s2} = 1;
		$finished_genes_all{$gene_s1_by_s2} = 1;
		$finished_genes{$gene_s2} = 1;
		$finished_genes{$gene_s3} = 1;
		$shared_between_all{$gene_s1_by_s2} = $UID;
		$shared_between_all{$gene_s2} = $UID;
		$shared_between_all{$gene_s3} = $UID;
		$UID++;
		 
			}
	$finished_genes_all{$gene_s2} = 1;
$finished_genes_all{$gene_s3} = 1;
}


########DOUBLETS#################

my $minus_strain1 =0;
my $minus_strain2 =0;
my $minus_strain3 =0;


##Mark Paired genes

#Sharedfile1
	foreach my $gene_s1 (sort keys %RBH_strain1_vs_strain2){
		my $gene_s2 = $RBH_strain1_vs_strain2{$gene_s1};
			next if (exists $finished_genes{$gene_s1});
			next if (exists $finished_genes{$gene_s2});
			if (exists $gene_uid{$gene_s1}){
			$gene_uid{$gene_s1} = $UID;
			$uid_gene_strain1{$UID}=$gene_s1;
			 $minus_strain1++;
			
			}else{
		$gene_uid{$gene_s1} = $UID;
		$uid_gene_strain1{$UID}=$gene_s1;
	}	
	if (exists $gene_uid{$gene_s2}){
			$gene_uid{$gene_s2} = $UID;
			$uid_gene_strain2{$UID}=$gene_s2;
			$minus_strain2++;
			}else{
		$gene_uid{$gene_s2} = $UID;
		$uid_gene_strain2{$UID}=$gene_s2;
	}	
	$UID++;
}

#Sharedfile2
foreach my $gene_s1 (sort keys %RBH_strain1_vs_strain3){
	my $gene_s3 = $RBH_strain1_vs_strain3{$gene_s1};
	next if (exists $finished_genes{$gene_s1});
	next if (exists $finished_genes{$gene_s3});
	if (exists $gene_uid{$gene_s1}){
			$gene_uid{$gene_s1} = $UID;
			$uid_gene_strain1{$UID}=$gene_s1;
			$minus_strain1++;
			}else{
		$gene_uid{$gene_s1} = $UID;
		$uid_gene_strain1{$UID}=$gene_s1;
	}	
	if (exists $gene_uid{$gene_s3}){
			$gene_uid{$gene_s3} = $UID;
			$uid_gene_strain3{$UID}=$gene_s3;
			$minus_strain3++;
			}else{
		$gene_uid{$gene_s3} = $UID;
		$uid_gene_strain3{$UID}=$gene_s3;
	}	
	$UID++;
	}


#Sharedfile3
foreach my $gene_s2 (sort keys %RBH_strain2_vs_strain3){
	my $gene_s3 = $RBH_strain2_vs_strain3{$gene_s2};
	next if (exists $finished_genes{$gene_s2});
	next if (exists $finished_genes{$gene_s3});
	if (exists $gene_uid{$gene_s2}){
			$gene_uid{$gene_s2} = $UID;
			$uid_gene_strain2{$UID}=$gene_s2;
			$minus_strain2++;
			}else{
		$gene_uid{$gene_s2} = $UID;
		$uid_gene_strain2{$UID}=$gene_s2;
	}	
	if (exists $gene_uid{$gene_s3}){
			$gene_uid{$gene_s3} = $UID;
			$uid_gene_strain3{$UID}=$gene_s3;
			$minus_strain3++;
			}else{
		$gene_uid{$gene_s3} = $UID;
		$uid_gene_strain3{$UID}=$gene_s3;
	}	
	$UID++;
}

#Assign $number_of_singlets_s1 UIDS to strian
my 	$number_of_multiples_s1 = keys %uid_gene_strain1;
my 	$number_of_multiples_s2 = keys %uid_gene_strain2;
my 	$number_of_multiples_s3 = keys %uid_gene_strain3; 

my $number_of_singlets_s1 = $number_of_genes_s1 - $number_of_multiples_s1;
my $number_of_singlets_s2 = $number_of_genes_s2 - $number_of_multiples_s2;
my $number_of_singlets_s3 = $number_of_genes_s3 - $number_of_multiples_s3;


####SINGLETS############

my $n1 = 0;
while ($n1 < $number_of_singlets_s1){
	$uid_gene_strain1{$UID} = $strain1."_singlet_s".$n1;
	$UID++;
	$n1++;
	}

my $n2 = 0;
while ($n2 < $number_of_singlets_s2){
	$uid_gene_strain2{$UID} = $strain2."_singlet_s".$n2;
	$UID++;
	$n2++;
	}

my $n3 = 0;
while ($n3 < $number_of_singlets_s3){
	$uid_gene_strain3{$UID} = $strain3."_singlet_s".$n3;
	$UID++;
	$n3++;
	}


#Output
#Print log
print $outhandle_log "Input:\n";
foreach my $flag (sort keys %inflag){
	print $outhandle_log $flag, "\t", $inflag{$flag}, "\n";
	}
print $outhandle_log "\nOutput:\n".
#$outfile."\n".
$outfile1."\n".
$outfile2."\n".
$outfile3."\n".
$outfile_all."\n";



#foreach my $gene (keys %gene_uid){
#	print  $outhandle $gene, "\t", $gene_uid{$gene}, "\n";
#}

foreach my $uid(sort {$a<=>$b} keys %uid_gene_strain1){
	print $outhandle1 $uid, "\n";
}
foreach my $uid(sort {$a<=>$b} keys %uid_gene_strain2){
	print $outhandle2 $uid, "\n";
}
foreach my $uid(sort {$a<=>$b} keys %uid_gene_strain3){
	print $outhandle3 $uid, "\n";
}
foreach my $gene (sort keys %shared_between_all){
	print $outhandle_all $gene, "\t", $shared_between_all{$gene}, "\n";
}



print "Done! The output are stored in the files\n$outfile", "\n".
"$outfile1", "\n".
"$outfile2", "\n".
"$outfile3", "\n".
"$outfile_log", "\n".
"$outfile_all", "\n".
"\n\n";



#I can Use this when I get the module to work, but so far I have cpan problem.
##### R

#if ($inflag{r} eq "y"){
#
 #    my $r_filename = "RBH_venn.".$strain1.".".$strain2.".".$strain3.".jpg";
    
##     $R->set( 'infile', $outfile);
 #    $R->set( 'contigs', $outfile_contigs);
  #   print $R->run_from_file($r_filename);

#}





# Original layout
##Perlscript for making RBH Venn diagram
##Input files: Tree files of RBH gene names for two organisms in two columns. 
##Three files with genenames
##Output: A UID for each gene. Shared genes share UID, 
##regardless if they are shared between two or three genomes
##A list of all genes and their gene UID
##Three files with only UID - one for each genome.
##Shunt on to R script to make Venn diagram


##Principle workflow
#Read each genelist - put in three separate hashes
#RBH1_all
#RBH2_all
#RBH3_all
#Make hash of all genes
#all_genes = RBH1_all, RBH2_all, RBH3_all
#Read each RBH-list - put in three separate hashes that contains BOTH set of gene names
#Strain1_vs_Strain2 #strain.genename1 = strain.genename2 #strain.genename2 = strain.genename1
#Strain2_vs_Strain3
#Strain3_vs_Strain1

#foreach (all_genes)
#Flag number of hashes shared
#shared in two = shared in all
#shared in one, shared between two
#Not shared = unique.
# Give UID




#####SUBS


	
###SUB	
#This subroutine takes a string that contains tabs and returns the first field and all the other fields, still tabdelimited. Perfect to put in a hash.
sub put_in_tab_hash_first_entry_as_key{

	my $line = $_[0];
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	my @list = split(/\t/, $line);
	my $key = $list[0];
	my $value = join("\t", @list[1..($#list)]); #join all except first element of list
	return($key, $value);
	}	
#Typical use:
#my %contig_hash; #contig = start, end, orientation
#while (my $line = <$inhandle1>){
#	   my ($key, $value) = put_in_tab_hash_first_entry_as_key($line);
#		$contig_hash{$key} = $value;
#	}


###SUB
#This subroutine breaks up a tabdelimited line to an array 
sub array_from_tab{
	my $line = $_[0];
	$line =~ s/\r|\n//g; #Remove newlines, regardless of format
	chomp $line;
	my @list = split(/\t/, $line);
	return @list;
}
#Typical use:
#my @list = array_from_tab($line);

###SUB
#Saves flag to the hash inflag, which is defined early in the script. Only flags defined in the hash is read.
sub save_flags{
	
	my $value_flag = 0;
	my $flag;
	my $value;

foreach(@_){
	if  (substr($_, 0,2) eq '-h' ){ #help
		print $helpfile, "\n";
		die;
	}  
	if ($value_flag == 1){ #value after flag
				die ("Flag - $flag is empty\n") if  (substr($_, 0,1) eq '-' );  #flag
				$value = $_;
				if (exists $inflag{$flag}){
					$inflag{$flag} = $value;
				}else{
					die ("Unknown flag - $flag");
				}
				$value_flag = 0;
				next;
		}
	if  (substr($_, 0,1) eq '-' ){  #flag
		$value_flag = 1;
		$flag = substr($_, 1,2);
		#print $flag, "\n";
	}else{
		die ("Not known input. Please write in form of flag.\n");
	}
}
if ($value_flag == 1){
	die ("Flag - $flag is empty\n");
}
}# end sub
#Typical use:
#Inflags. If default value is NULL - no default value is used.
#my %inflag = ("i" , "NULL", #infile mpileup
 #          "o" ,    "$outfilesuffix", #output
  #         "t",    "10", #treshold
	#	   "g", "NULL", #gff file
	#	   );
	#save_flags(@ARGV);
	
