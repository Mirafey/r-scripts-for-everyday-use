# How to run simulations in arm or rstanarm the same way as in Zelig

# Create a data set
x <- rnorm(100,20,10)
z <- rnorm(100,10,5)
e <- rnorm(100,0,1)
y <- 2*x+3*z+e
df <- data.frame(y,x,z)

# Using Zelig
require(Zelig)

m1.zelig <- zelig(y ~ x + z, model="ls", data=df)
summary(m1.zelig)

# Simulating x = 40 and z = 10
s1 <- setx(m1.zelig, x = 40, z = 10)
simulation <- Zelig::sim(m1.zelig, x = s1)
summary(simulation)

# Running the same model with arm
require(arm)
m1.arm <- bayesglm(y ~ x + z, data=df)
summary(m1.arm)

# Now we simulate data "by hand". First, we create a vector with the same
# dimensions as the data set. Let us call it `s2`. 

s2 <- data.frame(intercept = 1, x = 40, z = 10)

# Now running the simulations with the arm package:
sims <- arm::sim(m1.arm, n = 1000)
y_sim <- rnorm(n = 1000, mean = sims@coef %*% t(as.matrix(s2)), sd = sims@sigma)
mean(y_sim)
plot(density(y_sim))

# The results should be the same for both.

## Using Fearon's data set and logistic regressions:

# Data set
library(foreign)
fearon <- read.dta("/yourfolder/repdata.dta")
fearon$onset <- ifelse(fearon$onset >= 1, 1, fearon$onset)

# Models:

# With Zelig:
m2.zelig <- zelig(onset ~ warl + gdpenl + lpopl1 + lmtnest,
                  model = "logit", data = fearon)

s3 <- setx(m2.zelig, warl = 0, gdpenl = 0, lpopl1 = 20, lmtnest = 2.17)
simulation2 <- Zelig::sim(m2.zelig, x = s3)
summary(simulation2)

# With arm:
m2.arm <- bayesglm(onset ~ warl + gdpenl + lpopl1 + lmtnest,
                   family = binomial (link="logit"), data = fearon)

s4 <- data.frame(intercept = 1, warl = 0, gdpenl = 0, lpopl1 = 20, lmtnest = 2.17)
sims <- arm::sim(m2.arm, n = 1000)
y_sim <- rbinom(n = 1000, size = 1, prob = plogis(sims@coef %*% t(as.matrix(s4))))
mean(y_sim)

