# Analysing behavioural recognition of de-faced MRIs
# rik.henson@mrc-cbu.cam.ac.uk & andrea.greve@mrc-cbu.cam.ac.uk July 2021

require(lme4)
require(ez)
require(BayesFactor)

rm(list = ls(all.names = TRUE)) 

# Load raw data
data_input <- read.csv("beh_data_cbu_ctb.csv")

data_input$subj    <- as.factor(data_input$subj)
data_input$order   <- as.factor(data_input$order)
data_input$face    <- as.factor(data_input$face)
data_input$cond    <- as.factor(data_input$cond)
data_input$grp     <- as.factor(data_input$grp)

levels(data_input$cond)[levels(data_input$cond)==1] <- "Intact"
levels(data_input$cond)[levels(data_input$cond)==2] <- "Defaced"
levels(data_input$cond)[levels(data_input$cond)==3] <- "Trimmed"

data_input$cond <- ordered(data_input$cond, levels = c('Intact','Trimmed','Defaced'))
str(data_input)

##############################################################################
## Average across trials

data_mean <- aggregate(data_input$acc, list(data_input$cond,data_input$subj,data_input$order,data_input$grp), mean)
names(data_mean) <- list('cond','subj','order','grp','mean_acc')

## Detect outliers (doesn't make difference to BFs below)
# Define by average over conditions..
# data_total <- aggregate(data_input$acc, list(data_input$subj), mean)
# names(data_total) <- list('subj','tot_acc')
# outliers     <- boxplot(data_total$tot_acc) # none

# Define by each condition and grp
#outliers     <- boxplot(data_mean$mean_acc ~ data_mean$cond * data_mean$grp) 

# Define by each condition, collapsing grp since no interaction with grp below
outliers     <- boxplot(data_mean$mean_acc ~ data_mean$cond) 

#Q1 <- quantile(data_mean$mean_acc, .25)
#Q3 <- quantile(data_mean$mean_acc, .75)
#IQR <- IQR(data_mean$mean_acc)
# Would have to repeat for each condition... data_mean <- subset(data_mean, data_mean$mean_acc > (Q1 - 1.5*IQR) & data_mean$mean_acc < (Q3 + 1.5*IQR))
# So quick way to remove outliers from visualising above boxplot!
outlier <- which((data_mean$cond == "Trimmed" & data_mean$mean_acc == 1) | (data_mean$cond == "Defaced" & data_mean$mean_acc > 0.69))
outlier <- data_mean[outlier,"subj"]
data_mean <- data_mean[which(!data_mean$subj %in% outlier),]
boxplot(data_mean$mean_acc ~ data_mean$cond) 


## ANOVA for Condition and Group 

#summary(aov(mean_acc ~ grp*cond + Error(subj/cond), data = data_mean))
#anova(lmer(mean_acc ~  cond*grp + (1|subj),data = data_mean))
ezANOVA(data_mean, dv = mean_acc, wid = subj, within = cond, between = grp, detailed=TRUE, type="III")
ezPlot(data_mean, dv = mean_acc, wid = subj, within = cond, between = grp, 
       split = grp, x = cond,  x_lab = 'cond', y_lab = 'acc') 

# https://benwhalley.github.io/datafluency/workshop-repeated-measures.html
bf <- anovaBF(mean_acc ~ cond*grp + subj, data = data_mean, 
              whichRandom = "subj", whichModels="withmain", iterations = 100000)
bf[1] # Main Effect of Condition
bf[2] # Main Effect of Group
bf[4] / bf[3] # ConditionxGroup interaction
bf[3] / bf[4] # BF01 for interaction

## Examine order effects - ie whether or not first condition attempted

data_mean$first <- factor(data_mean$order == 1)
ezANOVA(data_mean, dv = mean_acc, wid = subj, between = .(cond,first), detailed=TRUE, type="III")
ezPlot(data_mean, dv = mean_acc, wid = subj, between = .(cond,first), 
       split = first, x = cond,  x_lab = 'cond', y_lab = 'acc') 
bf <- anovaBF(mean_acc ~ cond*first + subj, data = data_mean, 
              whichRandom = "subj", whichModels="withmain", iterations = 100000)
bf[2] # Main Effect of Order
bf[4] / bf[3] # ConditionxOrder interaction

## Pairwise tests (for First blocks)
data_intact_trimmed <- subset(data_mean, cond != "Defaced" & order == 1)
t.test(x = data_intact_trimmed$mean_acc[data_intact_trimmed$cond=="Intact"], y = data_intact_trimmed$mean_acc[data_intact_trimmed$cond=="Trimmed"], paired=FALSE)
#bf <- anovaBF(mean_acc ~ cond, data = data_intact_trimmed, 
#              whichRandom = "subj", whichModels="withmain", iterations = 100000)
#bf[1] # Difference between Intact and Trimmed 
#bf <- ttestBF(x = data_intact_trimmed$mean_acc[data_intact_trimmed$cond=="Intact"], y = data_intact_trimmed$mean_acc[data_intact_trimmed$cond=="Trimmed"], paired=FALSE)
#bf

data_trimmed_defaced <- subset(data_mean, cond != "Intact" & order == 1)
t.test(x = data_trimmed_defaced$mean_acc[data_trimmed_defaced$cond=="Trimmed"], y = data_trimmed_defaced$mean_acc[data_trimmed_defaced$cond=="Defaced"], paired=FALSE)
#bf <- anovaBF(mean_acc ~ cond, data = data_trimmed_defaced, 
#              whichRandom = "subj", whichModels="withmain", iterations = 100000)
#1/bf[1] # BF01 for Difference between Trimmed and Defaced 
bf <- ttestBF(x = data_trimmed_defaced$mean_acc[data_trimmed_defaced$cond=="Trimmed"], y = data_trimmed_defaced$mean_acc[data_trimmed_defaced$cond=="Defaced"], paired=FALSE)
1/bf

# data_intact_defaced <- subset(data_mean, cond != "Trimmed" & order == 1)
# t.test(x = data_intact_defaced$mean_acc[data_intact_defaced$cond=="Intact"], y = data_intact_defaced$mean_acc[data_intact_defaced$cond=="Defaced"], paired=FALSE)
# #bf <- anovaBF(mean_acc ~ cond, data = data_intact_defaced, 
# #              whichRandom = "subj", whichModels="withmain", iterations = 100000)
# #bf[1] # Difference between Intact and Defaced 
# ttestBF(x = data_intact_defaced$mean_acc[data_intact_defaced$cond=="Intact"], y = data_intact_defaced$mean_acc[data_intact_defaced$cond=="Defaced"], paired=FALSE)


## Versus Chance (0.1, or 0.2 if can detect sex)
t.test(x = data_mean$mean_acc[data_mean$cond=="Intact" & data_mean$order == 1], mu = 0.1, paired=FALSE)
# ttestBF(x = data_mean$mean_acc[data_mean$cond=="Intact" & data_mean$order == 1], mu = 0.1, paired=FALSE)
t.test(x = data_mean$mean_acc[data_mean$cond=="Trimmed" & data_mean$order == 1], mu = 0.1, paired=FALSE)
# ttestBF(x = data_mean$mean_acc[data_mean$cond=="Trimmed" & data_mean$order == 1], mu = 0.1, paired=FALSE)
t.test(x = data_mean$mean_acc[data_mean$cond=="Defaced" & data_mean$order == 1], mu = 0.1, paired=FALSE)
# ttestBF(x = data_mean$mean_acc[data_mean$cond=="Defaced" & data_mean$order == 1], mu = 0.1, paired=FALSE)

t.test(x = data_mean$mean_acc[data_mean$cond=="Intact" & data_mean$order == 1], mu = 0.2, paired=FALSE)
# ttestBF(x = data_mean$mean_acc[data_mean$cond=="Intact" & data_mean$order == 1], mu = 0.2, paired=FALSE)
t.test(x = data_mean$mean_acc[data_mean$cond=="Trimmed" & data_mean$order == 1], mu = 0.2, paired=FALSE)
bf <- ttestBF(x = data_mean$mean_acc[data_mean$cond=="Trimmed" & data_mean$order == 1], mu = 0.2, paired=FALSE)
1/bf
t.test(x = data_mean$mean_acc[data_mean$cond=="Defaced" & data_mean$order == 1], mu = 0.2, paired=FALSE)
bf <- ttestBF(x = data_mean$mean_acc[data_mean$cond=="Defaced" & data_mean$order == 1], mu = 0.2, paired=FALSE)
1/bf

##############################################################################
## Analyse all trials

## Particular Faces?

ezPlot(data_input, dv = acc, wid = subj, within = face, x = face, x_lab = 'face', y_lab = 'acc') # Johan and Rik easy!

data_defaced <- subset(data_input, cond == "Defaced")
ezPlot(data_defaced, dv = acc, wid = subj, within = face, x = face, x_lab = 'face', y_lab = 'acc') # Johan and Rik easy!

# Just repeat above analyses at single-trial level
# mat <- rbind(c(1, -1, 0),    # Intact vs Trimmed
#              c(0,1, -1))     # Trimmed vs Defaced
#require(MASS)
#cMat <- ginv(mat)
# glm_out = glmer(acc ~ cond*grp + (cond|subj) + (1|face), # singular unless remove random slopes?
#                 data = data_input,
#                 family = binomial,
#                 contrasts = list(cond = cMat),
#                 control = glmerControl(optimizer = "bobyqa"),
#                 nAGQ = 1)
# anova(glm_out)
# summary(glm_out)

# Get data from first block, and only from CBU (since CTB not familiar with faces)
data_cbu <- subset(data_input, grp == "cbu")

# Could do "brms" for BFs...
# Test for effect of familiarity
glm_out = glmer(#acc ~ cond*factor(fam) + (1|subj) + (1|face), # too much?
                acc ~ cond*order*fam + (1|subj) + (1|face), # linear only
                data = data_cbu,
                family = binomial,
                control = glmerControl(optimizer = "bobyqa"),
                nAGQ = 1)
summary(glm_out)
tmp <- anova(glm_out)
tmp

#Main effect of familiarity p-value
pf(tmp$`F value`[3], 1, 1474, lower.tail = FALSE) # for linear; denominator df comes from summary (can't be bothered to automate!)
pf(tmp$`F value`[4], 6, 1474, lower.tail = FALSE) # for linear; denominator df comes from summary (can't be bothered to automate!)

## Does fam affect pairwise comparisons of Trimmed
data_first_cbu_intact_trimmed <- subset(data_cbu, cond != "Intact" & order == 1)
glm_out = glmer(#acc ~ cond*factor(fam) + (1|subj) + (1|face), # too much?
                acc ~ cond*fam + (1|subj) + (1|face), # above coefficients look linear
                data = data_first_cbu_intact_trimmed,
                family = binomial,
                control = glmerControl(optimizer = "bobyqa"),
                nAGQ = 1)
summary(glm_out)
tmp <- anova(glm_out)
tmp

#Main effect of condition still significant
pf(tmp$`F value`[1], 1, 284, lower.tail = FALSE) # trimmed vs defaced



####################################################################################






