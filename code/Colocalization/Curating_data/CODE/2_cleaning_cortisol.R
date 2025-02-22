##############
#INTRODUCTION#
##############

#This code is to curate cortisol data.

###################
#Loading libraries#
###################

library(tidyverse)
library(data.table)
library(TwoSampleMR)
library(jsonlite)
library(httr)

###################
#Loading functions#
###################

beta_retriever <- function(header_info){
  
  beta <- strsplit(header_info, ":")[[1]][1]
  
  return(beta)
  
}

se_retriever <- function(header_info){
  
  se <- strsplit(header_info, ":")[[1]][2]
  
  return(se)
  
}

se_retriever_2 <- function(header_info){
  
  se <- strsplit(header_info, ":")[[1]][4]
  
  return(se)
  
}

logp_retriever <- function(header_info){
  
  logp <- strsplit(header_info, ":")[[1]][3]
  
  return(logp)
  
}

#EAF_retriever <- function(header_info){
#  
#  EAF <- strsplit(header_info, ":")[[1]][4]
#  
#  return(EAF)
#  
#}


rsid_retriever <- function(header_info){
  
  rsid <- strsplit(header_info, ":")[[1]][4]
  
  return(rsid)
  
}

rsid_retriever_2 <- function(header_info){
  
  rsid <- strsplit(header_info, ":")[[1]][2]
  
  return(rsid)
  
}


ld_proxies_MGU <- function(snp){
  #Enter vector of SNPs it will output all its LD friends from 1KG European LD friends with r2 > 0.8
  #in 500kb.
  
  fake_df <- t(as.data.frame(c("d_prime", "variation2", "population_name", "r2", "variation1")))
  
  colnames(fake_df) <- fake_df[1,]
  rownames(fake_df) <- c(1)
  
  #Setting the server:
  
  server <- "http://grch37.rest.ensembl.org"
  
  for(i in snp){
    
    ext_1 <- paste("/ld/human/", i, sep = "")
    ext_2 <- paste(ext_1, "/1000GENOMES:phase_3:EUR", sep = "")
    
    r <- GET(paste(server, ext_2, sep = ""), content_type("application/json"))
    new <- fromJSON(toJSON(content(r)))
    
    fake_df <- rbind(fake_df, new)
    
  }
  
  #Now filtering for those that are in high LD:
  
  final_df <- fake_df[which(as.numeric(fake_df$r2) > 0.8),] #The NAs by coercion are the rows from the fake_df, ignore them!
  
  return(final_df)
  
}

##############
#Loading data#
##############

cortisol_data<-fread("J:/CBMR/SUN-CBMR-Kilpelainen-Group/Team projects/Mario&German/Smoking_WHR/CODE_4_Replication/RAW_Data/for_colocalization/gwama_maf0.01_n10k.txt", stringsAsFactors = FALSE)

#We are also gonna load the genome-wide significant SNPs to be able to see if the data
#matches and check whether we have weird results or not with this format.

#######################
#REFORMATTING THE DATA#
#######################

#Now that we know the basics of the data.
#Let's start by making some functions to make it work:

cortisol_data_copy <- cortisol_data

colnames(cortisol_data_copy) <- c("SNP", "chr.outcome", "pos.outcome", "effect_allele.outcome", "other_allele.outcome", "eaf.outcome", "eaf_se.outcome", "min_eaf.outcome", "max_eaf.outcome","beta.outcome", "se.outcome", "pval.outcome", "dir.outcome", "HetISq", "HetChiSq", "HetDf", "HetPVal", "samplesize.outcome")

############
#FINISHED!!#
############

##########
#CURATION#
##########

#We don't have INFO, so we cannot rely on that. 
#The MAF cannot be done, we do not have this data.
#Proceed carefully. 

cortisol_data_maf <- cortisol_data_copy[which(cortisol_data_copy$eaf.outcome > 0.01),]
cortisol_data_maf <- cortisol_data_maf[which(cortisol_data_maf$eaf.outcome < 0.99),]

#We go from 9.2M to 7.7M. Good enough!!

#2. Now we remove the MHC region:

cortisol_data_maf_mhc <- cortisol_data_maf[which(as.numeric(cortisol_data_maf$chr.outcome) == 6 & as.numeric(cortisol_data_maf$pos.outcome) >= 26000000 & as.numeric(cortisol_data_maf$pos.outcome) <= 34000000),]

summary(as.numeric(cortisol_data_maf_mhc$chr.outcome)) #perfect.
summary(as.numeric(cortisol_data_maf_mhc$pos.outcome)) #perfect.

#Now let's check if we had any interesting variants there:

summary(as.numeric(cortisol_data_maf_mhc$pval.outcome)) #we actually do. But we said we should remove it so...

cortisol_data_maf_no_mhc <- cortisol_data_maf[which(!(cortisol_data_maf$SNP%in%cortisol_data_maf_mhc$SNP)),]

#3. We should have done that before. But let's check whether we are in build 37. I already know that it is, hence why I just check it here.

head(cortisol_data_maf_no_mhc)

#Perfect.

#4. Let's check the RSIDs:

head(cortisol_data_maf_no_mhc)

#We have no rsIDs, but we can work with the chromosome and the position.
#The rest of the SNPs have it, so as long as the alleles match, we won't have any issues.

#Let's get chr_pos:

cortisol_data_maf_no_mhc$chr_pos <- paste("chr", cortisol_data_maf_no_mhc$chr.outcome, ":", cortisol_data_maf_no_mhc$pos.outcome, sep = "")

cortisol_data_end <- cortisol_data_maf_no_mhc %>%
  select(SNP, chr.outcome, pos.outcome, effect_allele.outcome, other_allele.outcome, beta.outcome, se.outcome, pval.outcome, samplesize.outcome, chr_pos)

#colnames(cortisol_data_end) <-c("variant", "chromosome","base_pair_location", "effect_allele", "other_allele",  "beta", "standard_error", "p_value", "sample_size", "chr_pos")

#We will do the co-localization with the chr_pos, no need for rsid, if they are not there in the first place.

######################################################################################
#Thus, let's save the data and match as much as possible with chromosome and position#
######################################################################################

#In the whole process we will be very careful if one of the SNPs RSID is not there.
#Because if that is the case we will have a problem when clumping.

fwrite(cortisol_data_end, "J:/CBMR/SUN-CBMR-Kilpelainen-Group/Team projects/Mario&German/Smoking_WHR/CODE_4_Replication/Colocalization/Curating_data/Curated_data/cortisol_curated.txt")

