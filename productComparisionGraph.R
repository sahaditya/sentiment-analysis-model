productid<-c("RedMi","samsung","MotoG5")
productPercent<-c(84,76,46)
productOunce<-c(280,500,215)
productTotal<-data.frame(productid,productPercent,productOunce)
productTotal
pMean<-tapply(productTotal$productOunce,factor(productPercent), mean, nm.ra = TRUE)
#barplot(pMean, col = 2:6)
ggplot(productTotal,aes(productid, y = productPercent))+geom_histogram(aes(fill = productid), stat = "identity")
productTotal
