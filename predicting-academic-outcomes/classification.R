library(tidyverse)
train<- read.csv("train.csv", header = TRUE)
test<- read.csv("test.csv", header = TRUE)

train <- train %>%
  rename(nationality = Nacionality) 

test <- test %>%
  rename(nationality = Nacionality) 

trainpc <- train[,2:37] # excluded id and target variable. 

pc.train <- princomp(trainpc, cor = TRUE)
pc.train

testpc <- test[,2:37]
pc.test <- princomp(testpc, cor = TRUE)

# output
names(pc.train)

# Summary 
summary(pc.train)

# Eigendecomposition
eigenvectors <- pc.train$loadings # these values are scaled so the SS = 1
eigenvalues <- pc.train$sdev*pc.train$sdev

round(cor(train[,2:37], pc.train$scores), 3)

# Scree Plot - determine no. of comp
screeplot(pc.train, type="l", main="Screeplot for Train Data")
abline(2.1,0, col="red", lty=2) # elbow showing around 3 or 4 pcs.

# Givn we have 3 pcs 
# Plot PC1 vs PC2
# plot(pc.train$scores[,1:2], type='n', xlab='PC1', ylab='PC2')
# points(pc.train$scores[,1:2], cex=0.5)
# text(pc.train$scores[,1:2], label = train[,1], cex = 0.5)

# PC1 vs PC2
# plot(pc.train$scores[,1], pc.train$scores[,2], type='n', xlab="PC1", ylab="PC2", main="PC1 vs PC2")
# points(pc.train$scores[,1:2], cex=0.5)
# text(pc.train$scores[,1:2], labels=train$id, cex = 0.5)
# 
# # PC1 vs PC3
# plot(pc.train$scores[,1], pc.train$scores[,3], type='n', xlab="PC1", ylab="PC3", main="PC1 vs PC3")
# points(pc.train$scores[,1:3], cex=0.5)
# text(pc.train$scores[,1:3], labels=train$id, cex = 0.5)
# 
# # PC2 vs PC3
# plot(pc.train$scores[,2], pc.train$scores[,3], type='n', xlab="PC2", ylab="PC3", main="PC2 vs PC3")
# points(pc.train$scores[,2:3], cex=0.5)
# text(pc.train$scores[,2:3], labels=train$id, cex = 0.5)

#Alternative method
pc.fit <- prcomp(train[,2:37], scale = TRUE)
eigenvalues <-pc.fit$sdev * pc.fit$sdev
eigenvectors <- pc.fit$rotation
summary(pc.fit)

# biplot
# biplot(pc.fit, scale = 0)
# biplot(pc.fit)
#screeplot(pc.test, type="l", main="Screeplot for Test Data")

pc_scores <- pc.train$scores[, 1:3]


pc_scores_test <- pc.test$scores[, 1:3]

#########################################################################################################

## Classification study




