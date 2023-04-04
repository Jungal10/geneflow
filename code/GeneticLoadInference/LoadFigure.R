#library(multcomp)
#library(lsmeans)
#library(postHoc)
library(cowplot)
library(multcompView)
library(ggplot2)
library(ggpattern)
library(ggpubr)

theme_cowplot(
   font_size = 14,
   font_family = "",
   line_size = 0.5,
   rel_small = 12/14,
   rel_tiny = 11/14,
   rel_large = 16/14)

theme_set(theme_cowplot())

######### Total Load # Fig(a)

data <- read.table("TotalLoad.txt", header=T, sep="\t")	
#anova(lm(AdditiveLoad ~ Species, data=data))
#model <- lm(AdditiveLoad ~ Species, data=data)
#summary(glht(model, lsm(pairwise ~ Species)))
### Posthoc from library- posthoc #
#model <- lm(AdditiveLoad ~ Species + 0, data=data)
#coef(model)
#tukey <- posthoc(model)
#summary(tukey)

############# using TukeyHSD

new_model <- aov(AdditiveLoad ~ Species, data=data)
tHSD <- TukeyHSD(new_model, ordered=FALSE, conf.level=0.95)
plot(tHSD , las=1 , col="brown" )
generate_label_df <- function(TUKEY, variable){
 Tukey.levels <- TUKEY[[variable]][,4]
   Tukey.labels <- data.frame(multcompLetters(Tukey.levels)['Letters'])   #I need to put the labels in the same order as in the boxplot :
   Tukey.labels$treatment=rownames(Tukey.labels)
   Tukey.labels=Tukey.labels[order(Tukey.labels$treatment) , ]
   return(Tukey.labels)
 }
 
model=lm(data$AdditiveLoad ~ data$Species)
ANOVA =aov(model)
TUKEY <- TukeyHSD(x=ANOVA, 'data$Species', conf.level=0.95)
labels <- generate_label_df(TUKEY, "data$Species")
names(labels)<-c('Letters','Species')

yvalue<-aggregate(x=data$AdditiveLoad, by=list(data$Species),quantile)
final <- data.frame(labels, yvalue)

#### Now actual plotting
 level_orderX <- c("caudatus", "cruentus","hypochondriacus","hybridus_CA","hybridus_SA","quitensis") ### reorder as wild and domesticated
p <- ggplot(data, aes(x = factor(Species,level=level_orderX),y = AdditiveLoad, fill = Species)) + 
     geom_boxplot() +
     theme(legend.position="none") +
     scale_fill_manual(values = c("#a6cee3","#1f78b4","#33a02c","#f8bf68","#b2df8a","#fb9a99"))
q <- p + labs(x="", y = "Total Load per individual")
figA <- q + theme(axis.text.x = element_text(size = 16, angle=45, hjust=1)) + theme(text = element_text(size = 16)) +
geom_text(data = final, aes(x = Species, y = x[,5], label = Letters),vjust=-0.8, fontface="bold", size=8) + 

#geom_text(data = final, aes(x = factor(Species,level=level_orderX), y = x[,4], label = Letters),vjust=-1.5,hjust=-.5) +
theme(legend.position="none") + scale_y_continuous(labels = function(x) format(x, scientific = TRUE))
ggsave("FigA.pdf")
############## Segregating Load- Fig (b)
data <- read.table("Additive-SegLoad.txt", header=T, sep="\t")

new_model <- aov(Load ~ Species, data=data)
tHSD <- TukeyHSD(new_model, ordered=FALSE, conf.level=0.95)

generate_label_df <- function(TUKEY, variable){
 Tukey.levels <- TUKEY[[variable]][,4]
   Tukey.labels <- data.frame(multcompLetters(Tukey.levels)['Letters'])   #I need to put the labels in the same order as in the boxplot :
   Tukey.labels$treatment=rownames(Tukey.labels)
   Tukey.labels=Tukey.labels[order(Tukey.labels$treatment) , ]
   return(Tukey.labels)
 }
 
model=lm(data$Load ~ data$Species)
ANOVA =aov(model)
TUKEY <- TukeyHSD(x=ANOVA, 'data$Species', conf.level=0.95)
labels <- generate_label_df(TUKEY, "data$Species")
names(labels)<-c('Letters','Species')

yvalue<-aggregate(x=data$Load, by=list(data$Species),quantile)
final <- data.frame(labels, yvalue)
## Plot

p <- ggplot(data, aes(x = factor(Species,level=level_orderX), y = Load, fill = Species)) + 
     geom_boxplot() +
     theme(legend.position="none") +
     scale_fill_manual(values = c("#a6cee3","#1f78b4","#33a02c","#f8bf68","#b2df8a","#fb9a99"))
q <- p + labs(x="", y = "Segregating Load per individual")
figB <- q + theme(axis.text.x = element_text(size = 16, angle=45,hjust=1)) + theme(text = element_text(size = 16)) +
geom_text(data = final, aes(x = Species, y = x[,5], label = Letters),vjust=-0.8, fontface="bold",size=8) +
theme(legend.position="none") + scale_y_continuous(labels = function(x) format(x, scientific = TRUE))
ggsave("FigB.pdf")

############## Fixed Load    fig(c)
data <- read.table("FixedLoad.txt", header=T, sep="\t")

p <- ggplot(data, aes(x = factor(Species,level=level_orderX), y = FixedLoad, fill = Species)) +
  geom_bar(stat="identity") +
  theme(legend.position="none") +
      scale_fill_manual(values = c("#a6cee3","#1f78b4","#33a02c","#f8bf68","#b2df8a","#fb9a99"))
q <- p + labs(x="", y = "Fixed Load")
figC <- q + theme(axis.text.x = element_text(size = 16, angle=45, hjust=1)) + theme(text = element_text(size = 16)) + theme(legend.position="none")
ggsave("FigC.pdf")

####### Selective Sweeps - fig (d-e) 
data <- read.table("Sweep_Load.txt", header=T, sep="\t")
#########Significance testing using t-test
cauttest <- t.test(AdditiveLoadPerSite ~Region, subset(data, Species == 'caudatus'))
cruttest <- t.test(AdditiveLoadPerSite ~Region, subset(data, Species == 'cruentus'))
hypottest <- t.test(AdditiveLoadPerSite ~Region, subset(data, Species == 'hypochondriacus'))
hcattest <- t.test(AdditiveLoadPerSite ~Region, subset(data, Species == 'hybridus_CA'))
hsattest <- t.test(AdditiveLoadPerSite ~Region, subset(data, Species == 'hybridus_SA'))
quittest <- t.test(AdditiveLoadPerSite ~Region, subset(data, Species == 'quitensis'))

sig <- c(cauttest$p.value,cruttest$p.value,hypottest$p.value,hcattest$p.value,hsattest$p.value,quittest$p.value)
Species <- c("caudatus", "cruentus","hypochondriacus","hybridus_CA","hybridus_SA","quitensis")
ttest <- data.frame(Species,sig)
#### get the asterisks for the corresponding p-value
stars.pval <- function(x){
  stars <- c("***", "**", "*", ".", "n.s.")
  var <- c(0, 0.01, 0.05, 0.10, 1)
  i <- findInterval(x, var, left.open = T, rightmost.closed = T)
  stars[i]
}
labels <- transform(ttest, stars = stars.pval(ttest$sig)) 
### get the y-cordinates for plotting the asterisks
yvalue<-aggregate(x=data$AdditiveLoadPerSite, by=list(factor(data$Species,level=level_orderX)),quantile)
final <- data.frame(labels, yvalue)
######### Now actual Plotting
 p <-  ggplot(data, aes(x = factor(Species,level=level_orderX), y = AdditiveLoadPerSite, fill = Species)) + 
       scale_fill_manual(values = c("#a6cee3","#1f78b4","#33a02c","#f8bf68","#b2df8a","#fb9a99"), guide="none") +
       geom_boxplot_pattern(aes(pattern=Region), pattern_spacing=0.02)      
q <- p + labs(x="", y = "Mean burden per site per individual") 
figD <- q + theme(axis.text.x = element_text(size = 16, angle=45,hjust=1)) + theme(text = element_text(size = 16)) +
geom_text(data = final, aes(x = Species, y = x[,5], label = stars),vjust=-1.0, fontface="bold",size=8) +
theme(legend.position="none")
ggsave("figD.pdf")

######## Second part
cauttest <- t.test(AdditiveLoadPerLoadSite ~Region, subset(data, Species == 'caudatus'))
cruttest <- t.test(AdditiveLoadPerLoadSite ~Region, subset(data, Species == 'cruentus'))
hypottest <- t.test(AdditiveLoadPerLoadSite ~Region, subset(data, Species == 'hypochondriacus'))
hcattest <- t.test(AdditiveLoadPerLoadSite ~Region, subset(data, Species == 'hybridus_CA'))
hsattest <- t.test(AdditiveLoadPerLoadSite ~Region, subset(data, Species == 'hybridus_SA'))
quittest <- t.test(AdditiveLoadPerLoadSite ~Region, subset(data, Species == 'quitensis'))

sig <- c(cauttest$p.value,cruttest$p.value,hypottest$p.value,hcattest$p.value,hsattest$p.value,quittest$p.value)
Species <- c("caudatus", "cruentus","hypochondriacus","hybridus_CA","hybridus_SA","quitensis")
ttest <- data.frame(Species,sig)
#### get the asterisks for the corresponding p-value
stars.pval <- function(x){
  stars <- c("***", "**", "*", ".", "n.s.")
  var <- c(0, 0.01, 0.05, 0.10, 1)
  i <- findInterval(x, var, left.open = T, rightmost.closed = T)
  stars[i]
}
labels <- transform(ttest, stars = stars.pval(ttest$sig)) 
### get the y-cordinates for plotting the asterisks
yvalue<-aggregate(x=data$AdditiveLoadPerLoadSite, by=list(factor(data$Species,level=level_orderX)),quantile)
final <- data.frame(labels, yvalue)
######### Now actual Plotting
 p <-  ggplot(data, aes(x = factor(Species,level=level_orderX), y = AdditiveLoadPerLoadSite, fill = Species)) + 
       scale_fill_manual(values = c("#a6cee3","#1f78b4","#33a02c","#f8bf68","#b2df8a","#fb9a99"), guide="none") +
       geom_boxplot_pattern(aes(pattern=Region), pattern_spacing=0.02)      
q <- p + labs(x="", y = "Mean burden per deleterious site per individual") 
figE <- q + theme(axis.text.x = element_text(size = 16, angle=45, hjust=1)) + theme(text = element_text(size = 16)) +
geom_text(data = final, aes(x = Species, y = x[,5], label = stars),vjust=-1.0, fontface="bold",size=8) +
theme(legend.position="none")
ggsave("FigE.pdf")
figD_Final <- ggarrange(figD, figE, ncol=2,nrow=1, common.legend=TRUE, legend="top")
ggsave("FigD_Final.pdf")
############ Introgressed Load - Fig(f)

data <- read.table("Load-SiteRatio-all.txt", header=T, sep="\t")

###Significance testing -one sample t-test 
comps <- expand.grid(unique(data$Species), unique(data$Donor))  ## make all combinations of Species and donors

for (i in 1:nrow(comps)) {
comps$pval[i] <- t.test((subset(data, Species == comps[i,1] & Donor == comps[i,2]))$Ratio, mu = 1, alternative = "two.sided")$p.value
}
colnames(comps) <- c("Species", "Donor","pval")  # rename the column names to match data frame

### get asterisks for sig.
signif.num <- function(x) {
     symnum(x, corr = FALSE, na = FALSE, legend = FALSE,
            cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
            symbols = c("***", "**", "*", ".", " "))
 }
stars <- signif.num(comps$pval)
labels <- data.frame(comps, stars)

### get yvalue for plotting asterisks
level_orderX <- c("caudatus", "cruentus","hypochondriacus","hybridus_CA","hybridus_SA","quitensis") ### reorder as wild and domesticated
level_orderDonor <- c("ambiguous","caudatus", "cruentus","hypochondriacus","hybridus_CA","hybridus_SA","quitensis") 

yvalue<-aggregate(x=data$Ratio, by=list((factor(data$Species,level=level_orderX)), factor(data$Donor,level=level_orderDonor)),quantile)
#### merge two data frames in same order
final <- merge(labels, yvalue, by.x=c("Species", "Donor"), by.y=c("Group.1","Group.2"))

##### Now Plotting

p <-  ggplot(data, aes(x = factor(Species,level=level_orderX), y = Ratio, fill = factor(Donor,level=level_orderDonor)), position = position_dodge(0.8)) + 
      geom_boxplot() +
     scale_fill_manual(values = c("#808080","#a6cee3","#1f78b4","#b2df8a","#33a02c","#f8bf68","#fb9a99"), name="Donor")
q <- p + labs(x="", y = "Relative introgression burden per individual)" )
figF <- q + theme(axis.text = element_text(size = 16)) + theme(text = element_text(size = 16)) +
 geom_hline(yintercept = 1, col="red", lty=2) +
 geom_text(data = final, aes(x= factor(Species,level=level_orderX), y = x[,5], label=stars, group= factor(Donor,level=level_orderDonor)),position = position_dodge(0.8), angle=90, cex=10, hjust=-0.5)
ggsave("FigF.pdf")



  

############## FINAL
topright <- plot_grid(figB, figC, labels = c("b","c"), label_size = 20, label_fontface="bold", ncol=1, align= "hv")
ggsave("topright.pdf")
top <- plot_grid(figA, topright, labels = c("a",""), label_size = 20, label_fontface="bold", ncol=2, align= "v")
ggsave("top.pdf")
middle <-  plot_grid(figD, figE, labels = c("d","e"), label_size = 20, label_fontface="bold", ncol=2, align= "v")
ggsave("middle.pdf")
lower <-  plot_grid(figF, labels = c("f"), label_size = 20, label_fontface="bold", ncol=1)
ggsave("lower.pdf")
main <- plot_grid(top, middle, lower, labels = c("","",""), label_size = 20, label_fontface="bold", ncol=1, align= "h")
ggsave("main.pdf")

plot_grid(top, figD_Final, lower, labels = c("","",""), label_size = 20, label_fontface="bold", ncol=1, align= "h")
ggsave("main1.pdf", height=20, width=19)

