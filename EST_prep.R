library(data.table)
library(dplyr)
library(ggplot2)

args <- commandArgs(trailingOnly = T)
# Read the multiple sequence alignment (MSA)
print(args[1])

# Read in the data
data <- fread(args[1])
colnames(data) <- c("Gene", "CHROM","POS", "Alignment","rate","codonPos","Spinaciaacia",	"macrorhiza",	"lomatogona",	"corolliflora","PhyloP")
data <- data[,c(2:4,7:10)]
data <- cbind.data.frame(data, 
                         EL10.2=substr(data$Alignment, 1, 1),
                         Beet1=substr(data$Alignment, 2, 2),
                         Beet2=substr(data$Alignment, 3, 3),
                         Beet3=substr(data$Alignment, 4, 4),
                         Beet4=substr(data$Alignment, 5, 5),
                         Beet5=substr(data$Alignment, 6, 6),
                         Beet6=substr(data$Alignment, 7, 7))
atomizeAllele <- function(x){
  if(is.na(x)){
    return("0,0,0,0")
  }
  else{
    if(x == "A"){
      return("1,0,0,0")
    } else if(x == "C"){
      return("0,1,0,0")
    } else if(x == "G"){
      return("0,0,1,0")
    } else if(x == "T"){
      return("0,0,0,1")
    } else {
      return("0,0,0,0")
    }
  }
}

data <- data %>%
  rowwise() %>%
  mutate(macrorhiza=atomizeAllele(macrorhiza),
         lomatogona=atomizeAllele(lomatogona),
         corolliflora=atomizeAllele(corolliflora)) %>%
  ungroup()

GetRefProp <- function(x){
  AlleleTable <- as.character(as.vector(x))
  return(paste(sum(AlleleTable=="A"), sum(AlleleTable=="C"), sum(AlleleTable=="G"), sum(AlleleTable=="T"),sep=","))
}

EST_output <- cbind.data.frame(apply(data[,8:14], 1, GetRefProp),
                               data$lomatogona,
			       data$corolliflora,
                               data$macrorhiza)

write.table(EST_output, "EST_input.txt", quote=F, row.names=F, col.names=F, sep="\t")
system("/90daydata/sugar_beet_genetic_improvement/Evan.Long/Caryophyllales/est-sfs-release-2.04/est-sfs config-JC.txt EST_input.txt seedfile.txt output-file-sfs.txt output-file-pvalues.txt", intern = TRUE)
AncMajorProb <- fread("output-file-pvalues.txt",fill=T) %>% filter(V1!=0) %>% select(V3)


GetAncAllele <- function(EST,Major)
  {
  if(Major>0.5){
    alleles <- as.numeric(strsplit(EST[1,1], ",")[[1]])
    Anc <-c("A","C","G","T")[which(alleles==max(alleles))]
    if(length(Anc)>1){
      return("NA")
    } else {
      return(Anc)
    }
  }
  else{
    alleles <- as.numeric(strsplit(EST[1,1], ",")[[1]])
    OutG1 <- as.numeric(strsplit(EST[1,2], ",")[[1]])
    OutG2 <- as.numeric(strsplit(EST[1,3], ",")[[1]])
    OutG3 <- as.numeric(strsplit(EST[1,4], ",")[[1]])
    outgroup_sum <- OutG1 + OutG2 + OutG3
    Anc <-c("A","C","G","T")[which(outgroup_sum==max(outgroup_sum))]
    if(length(Anc)>1){
      return("NA")
    } else {
      return(Anc)
    }
  }
}

AncAllele <- vector(length=nrow(EST_output))
for(x in 1:nrow(EST_output)){
  AncAllele[x] <- GetAncAllele(EST_output[x,],AncMajorProb[x,1])
}



###Get on + Strand
gff <- fread(args[2])
orientation <- gff[1,7]

OrtientAncAllele <- function(x) 
{
if(x == "A"){
      return("T")
    } else if(x == "C"){
      return("G")
    } else if(x == "G"){
      return("C")
    } else if(x == "T"){
      return("A")
    } else {
      return("NA")
    }
}

if(orientation =="-"){
	AncAllele <- sapply(AncAllele, OrtientAncAllele)
}



write.table(AncAllele,"AncestralAllele.txt",col.names=F,row.names=F,quote=F,sep="\t")


