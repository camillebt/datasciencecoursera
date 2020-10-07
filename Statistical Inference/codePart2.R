data("ToothGrowth")

#Plot supplement vs length
ggplot(aes(x=supp, y=len), data=ToothGrowth)+ 
  geom_boxplot(aes(fill=supp))+ 
  xlab("Supplement") +ylab("Tooth length") +
  scale_fill_discrete(labels = c("Orange Juice", "Vitamin C"))


t.test(ToothGrowth$len[ToothGrowth$supp=="OJ"],
       ToothGrowth$len[ToothGrowth$supp=="VC"],
       paired = FALSE,var.equal = FALSE)

#Plot dosage vs length
ToothGrowth$dose <-as.factor(ToothGrowth$dose)
ggplot(aes(x=dose, y=len), data=ToothGrowth)+ 
  geom_boxplot(aes(fill=dose))+ 
  xlab("Dosage") +ylab("Tooth length")

#t-Test to check if means are significantly different
t.test(ToothGrowth$len[ToothGrowth$dose=="1"],
       ToothGrowth$len[ToothGrowth$dose=="2"],
       paired = FALSE,var.equal = FALSE)
