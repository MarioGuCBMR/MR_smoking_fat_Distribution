# Estimating causality between smoking and abdominal obesity by Mendelian randomization

This repository contains the code to reproduce the MR analysis to assess the causilty between smoking and abdominal obesity. The publication can be found in: https://onlinelibrary.wiley.com/doi/10.1111/add.16454

## Software used in the analysis:

A total of 4 Mendelian Randomization Methods were used:

Traditional mendelian randomization pipeline using TwoSampleMR package (v0.5.6: https://mrcieu.github.io/TwoSampleMR/)

CAUSE-MR (v1.0.0, install it here: https://github.com/jean997/cause)

LHC-MR (v1.0.0, install it from here: https://github.com/LizaDarrous/lhcMR)

MVMR (v0.4, install it from here: https://github.com/WSpiller/MVMR)

Additionally, genetic risk scores of IVs with fat depots and hormonal GWAS summary statistics were performed with the function grs.summary from the package (gtx, v.0.8.0). This function calculates the joint effects of a set of variants on an outcome trait using only GWAS summary statistics from the exposure and the outcome.
The package can be downloaded from here: https://github.com/tobyjohnson/gtx

### Packages requiered:

Importantly, all code for 2SMR codes start by loading several libraries: 

```
All of the following can be downloaded using install.packages() function:

library(ggplot2)
library(ggrepel)
library(dplyr)
library(gridExtra)
library(rmarkdown)
library(data.table)
library(jsonlite)
library(httr)
library(tidyverse)
library(phenoscanner)
```

### Additional information:

2SMR, MVMR and GRS code were run locally in a Windows 10 computer. CAUSE and LHC-MR were run in Computerome C2 (https://www.computerome.dk/).

## GWAS summary statistics used:

In this publication we are testing whether there is any causal association between smoking traits and fat distribution. To do so we used the latest and largest GWAS summary statistics for each of the traits. 

### Smoking traits:

For smoking traits we decided to use:

Lifetime smoking from Wottonn et al 2020 (available here: https://data.bris.ac.uk/data/dataset/10i96zb8gm0j81yz0q6ztei23d)

Smoking initiation from Liu et al 2019 (available here: https://conservancy.umn.edu/handle/11299/201564).

Cigarettes per day (past and current smokers) from Liu et al (available here: https://conservancy.umn.edu/handle/11299/201564).

Cigarettes per day (current smokers) from Elseworht et al (available here: https://gwas.mrcieu.ac.uk/datasets/ukb-b-469/) #doble check

Packs-year from Elseworth et al (available here: https://gwas.mrcieu.ac.uk/datasets/ukb-b-7460/) #double-check

For detailed information on the curation of the data and selection of IVs for each MR method, please check the Methods and Supplementary information of each paper.

### Fat distribution traits:

As outcome we used the following fat distribution traits: waist-hip ratio (WHR), body mass index adjusted WHR (WHRadjBMI), waist circumference (WC), BMI-adjusted WC (WCadjBMI), hip circumference (HC), BMI-adjusted hip circumference (HCadjBMI), WHRadjBMI statified for smokers and WCadjBMI stratified for smokers. 

The GWAS summary statistics utilized for each analysis might differ since traditional MR analysis are sensitive to sample overlap, while CAUSE and LHC-MR can control for it.

For 2SMR the summary statistics used are:

WHR: Shungin et al 2015 (available at: https://portals.broadinstitute.org/collaboration/giant/images/5/54/GIANT_2015_WHR_COMBINED_EUR.txt.gz)

WHR adjusted for body mass index: Shunging et al 2015 (available at: https://portals.broadinstitute.org/collaboration/giant/images/e/eb/GIANT_2015_WHRadjBMI_COMBINED_EUR.txt.gz)

WC: Shunging et al 2015 (available at: https://portals.broadinstitute.org/collaboration/giant/images/5/57/GIANT_2015_WC_COMBINED_EUR.txt.gz)

HC: Shungin et al 2015 (available at: https://portals.broadinstitute.org/collaboration/giant/images/e/e4/GIANT_2015_HIP_COMBINED_EUR.txt.gz)

WC adjusted for BMI: Shunging et al 2015 (available at: https://portals.broadinstitute.org/collaboration/giant/images/7/73/GIANT_2015_WCadjBMI_COMBINED_EUR.txt.gz)

HC adjusted for BMI: Shunging et al 2015 (available at: https://portals.broadinstitute.org/collaboration/giant/images/5/52/GIANT_2015_HIPadjBMI_COMBINED_EUR.txt.gz)

WHR adjusted for BMI stratified for smokers: Justice et al 2017 (available at: https://portals.broadinstitute.org/collaboration/giant/images/1/1c/WHRadjBMI.Stratified.zip)

WC adjusted for BMI stratified for smokers: Justice et al 2017 (available at: https://portals.broadinstitute.org/collaboration/giant/images/3/35/WCadjBMI.Stratified.zip)

For CAUSE and LHC-MR the summary statistics we particularly used GWAS summary statistics with bigger sample sizes for HC, WC, WHR, and WHRadjBMI:

WC Elseworth et al 2018 (available at: https://gwas.mrcieu.ac.uk/datasets/ukb-b-9405/) #check with code to be sure

HC: Elseworth et al 2018 (available at: https://gwas.mrcieu.ac.uk/datasets/ukb-b-15590/) #check with code to be sure

WHR : Pulit et al 2019: (available: https://zenodo.org/record/1251813/files/whr.giant-ukbb.meta-analysis.combined.23May2018.txt.gz?download=1)

WHR adjusted for body mass index: Pulit et al 2019: (available: https://zenodo.org/record/1251813/files/whradjbmi.giant-ukbb.meta-analysis.combined.23May2018.txt.gz?download=1)

### Fat depot traits:

GWAS summary statistics of fat depots from Agrawal et al 2022 can all be downloaded in [https://cvd.hugeamp.org/.](https://personal.broadinstitute.org/ryank/Agrawal_2022_Fat_Depots_GWAS.zip).

The zip file from the link above includes many GWAS summary statitics. We used to the sex-combined data for the following traits:

Abdominal subcutaenous adipose tissue (ASAT)
Gluteofemoral subcutaneous adipose tissue (GSAT)
Visceral adipose tissue (VAT)
VAT/ASAT ratio.
VAT/GSAT ratio.
ASAT/GSAT ratio.

Importantly, for some analysis we used BMI-adjusted versions for the three first traits (ASATadjBMI, GSATadjBMI and VATadjBMI). These summary statistics are not available online and should be confused with the BMI&height-adjusted traits that can be found in the link above. After direct contact with the authors, Agrawal et al made these summary statistics files available for the corresponding BMI-adjusted versions of the fat depot traits. I would like to use this space as well to thank Agrawal and Saaket again for their assistance and contribution. 
