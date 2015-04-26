require(robustbase)
setwd("C:/Lab/Patient Samples Nanowell/New Code for Median Hypothesis Testing")
load("Aggregate.Rdata")

setwd("C:/Lab/Patient Samples Nanowell/New Code for Median Hypothesis Testing/20140813 CTC308")

CD45 = read.csv("Before 5X_F_CY3.csv",header=TRUE)
PE = read.csv("After PCR_5X F_CY3.csv",header=TRUE)
FITC = read.csv("After PCR_5X F_GFP.csv",header=TRUE)

PE = subset(PE,!(is.na(CD45$O_75th)))
FITC = subset(FITC,!(is.na(CD45$O_75th)))
CD45 = subset(CD45,!(is.na(CD45$O_75th)))

Sig_Value = abs(qt(0.05/nrow(CD45),nrow(CD45)))

CD45.corr = (CD45$O_75th-CD45$Sq_Mean)/CD45$Sq_Mean

Med.corr = CD45_Agg$CD45_Mean
SD.corr = CD45_Agg$CD45_SD

CD45.possible = as.numeric((CD45.corr-Med.corr-Sig_Value*SD.corr)>0)+1

#tiff("Pre_PCR.tiff",width=421,height=355)
plot(CD45.corr,ylab = "CD45-PE Intensity (A.U.)",xlab = "Well Index",main="Pre-PCR",col=CD45.possible,pch=CD45.possible)
abline(h=Med.corr + Sig_Value*SD.corr,col=3)
legend("topright",c('High Mean'),col=c(2,3),pch=c(2,NA),lty=c(NA,1),cex=0.7,ncol=2)
#dev.off()

CTC_Bonferroni_TF = (CD45.corr>(Med.corr + Sig_Value*SD.corr))
table(CTC_Bonferroni_TF)
# CD45-subtracted by Bonferroni
PE_B = subset(PE,!(CTC_Bonferroni_TF))
FITC_B = subset(FITC,!(CTC_Bonferroni_TF))

Sig_Value_B = abs(qt(0.05/nrow(PE_B),nrow(PE_B)))


PE_B.corr = (PE_B$O_75th-PE_B$Sq_Mean)/PE_B$Sq_Mean

PE_B.Med.corr = PE_Agg$PE_Mean

PE_B.SD.corr = (PE_Agg$PE_SD+PE_Agg$PE_SN)/2

PE_B.possible = as.numeric((PE_B.corr-PE_B.Med.corr-Sig_Value_B*PE_B.SD.corr)>0)*1

FITC_B.corr = (FITC_B$O_75th-FITC_B$Sq_Mean)/FITC_B$Sq_Mean

FITC_B.Med.corr = FITC_Agg$FITC_Mean

FITC_B.SD.corr = (FITC_Agg$FITC_SD+FITC_Agg$FITC_SN)/2

FITC_B.possible = as.numeric((FITC_B.corr-FITC_B.Med.corr-Sig_Value_B*FITC_B.SD.corr)>0)*2

All_B.possible = PE_B.possible + FITC_B.possible + 1

#tiff("PostPCR_MeanSub.tiff",width=421,height=355)
plot(x=FITC_B.corr,y=PE_B.corr,ylab = "PE Intensity (A.U.)",xlab = "FITC Intensity (A.U.)",main="Post-PCR (Mean subtracted)",,col=All_B.possible)
abline(h=(PE_B.Med.corr + Sig_Value_B*PE_B.SD.corr),col=3)
abline(v=(FITC_B.Med.corr + Sig_Value_B*FITC_B.SD.corr),col=3)
legend("topright",c('PE High','FITC High','PE/FITC High','Bonferroni'),col=c(2,3,4,3),pch=c(1,1,1,NA),lty=c(NA,NA,NA,1),cex=0.6,ncol=2,bg='transparent')
#dev.off()

Corr_Int_B = data.frame(FITC_B.corr,PE_B.corr)

CTC_B_PE_TF_NoWBC = (Corr_Int_B$FITC_B.corr>(FITC_B.Med.corr + Sig_Value_B*FITC_B.SD.corr))
CTC_B_FITC_TF_NoWBC = (Corr_Int_B$PE_B.corr>(PE_B.Med.corr + Sig_Value_B*PE_B.SD.corr))
table(CTC_B_PE_TF_NoWBC,CTC_B_FITC_TF_NoWBC)

