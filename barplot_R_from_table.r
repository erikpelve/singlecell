#R script
#barplot_R_from_table.r

#This is a learning by doing thing, so expect lots of weirdness

#Input: file.txt, tabbulated txt-file. The first colum is groups that are to become each individual graph

# I copy the entire input file to each variable, then I remove all lines that doesn't belong. Very effective!

##read file
variable <- read.table("file.txt", header=TRUE)


##Separate the file into different variables. Each variable for a graph

# The different groups as defined by the first column. I'm sure there is a very elegant way to take the names from the file 
Group1 <- variable
Group2 <- variable
Group3 <- variable


#r is line number
#x is number of time I pulled a line
#a is line number corrected for number of times I pulled a line

#Again, here I add the total number of rows as a constant. Must be possible to get from file

x <-0
for (r in 1:9) {if (variable[r,1] != c("Group1")){a <- r - x; x <- x+1; Group1 <- Group1[-a,];}}

#And I loop the entire thing once for each variable. Oh my

x <-0
for (r in 1:9) {if (variable[r,1] != c("Group2")){a <- r - x; x <- x+1; Group2 <- Group2[-a,];}}


x <-0
for (r in 1:9) {if (variable[r,1] != c("Group3")){a <- r - x; x <- x+1; Group3 <- Group3[-a,];}}

##test
Group1
Group2
Group3


##Make plots

