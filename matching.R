# Matching is an statistical procedure that finds observations that are
# "similar enough" and tries to evaluate the effect of a given treatment
# in non-experimental data. Gelman and Hill (2003), and Gary King et al (2011)
# (http://gking.harvard.edu/matchit) have talked about it. Several articles use
# this technique. A few examples: Giligan and Sergenti "Do UN Interventions 
# Cause Peace? Using Matching to Improve Causal Inference" (QJPS, 2008:3), and
# Nielsen et al "Foreign Aid Shocks as a Cause of Violent Armed Conflict",
# (AJPS, 2011:55(2)). 

# Estimating it with R is very simple. We load the "MatchIt" and "cem" packages
# written by Gary King and his colleages. There are several types of matching
# algorithms, here I use only 2 of them. We always have to check which is the
# best-suited one for the job. A review of each matching algorithm included in
# "MatchIt" can be found on Gary King's website.

library(MatchIt) # matching package
library(cem) # a new algorithm for matching. Read the manual!
library(rgenoud) # genetic matching
library(Zelig) # turnout data set


# Now we will estimate the effect of race on voter turnout, trying to find pairs
# that could be meaninfully compared. 
# First, we run the matchit() command on the treatment variable, including the
# other pretreatment independent variables that you wish to include in the model
# Using the "cem" method by King et al:
data(turnout)
turnout <- data.frame(na.omit(turnout)) #remove NA's
turnout$race1 <- ifelse(turnout$race=="white",0, 1) # recode treatment as non-white
match1 <- matchit(race1 ~ age + educate + income, data = turnout,  method = "cem")
summary(match1)
match2 <- matchit(race1 ~ age + educate + income, data = turnout,  method = "nearest",
                  discard = "hull.both", # discard both control and treated that are
                  # outside of the convex hull test. 
                  # See: http://r.iq.harvard.edu/docs/matchit/2.4-20/matchit.pdf pg. 24
                  replace = TRUE, # observations can be matched many times
                  ratio = 2) # number of control units to match to each treated unit
                  
summary(match2)

# One easily realises that the data set is now more balanced. The means of
# the control and the treatment group are very similar. Some plots:
plot(match2)
plot(match2, type = "hist")
plot(match2, type = "jitter", interactive = FALSE)

# Seving the object
m.data <- match.data(match2)
summary(m.data)
head(m.data)

# To obtain matched data for the treatment or control group, 
# specify the option group as follows,
m.data2 <- match.data(match2, group = "treat")
summary(m.data2)
m.data3 <- match.data(match2, group = "control")
summary(m.data3)

# Running the model and forcing the data.frame directly in the command
model1 <- zelig(vote ~ race1 + age + educate + income, data = match.data(match2),
                model = "logit")
summary(model1)

# Then we simulate the effects when race1 = 0 or 1.
library(arm) # Gelman et al's great package

sim0 <- data.frame(intercept = 1, race1 = 0, age = mean(turnout$age),
                   educate = mean(turnout$educate), income = mean(turnout$income))
sims <- arm::sim(model1, n = 1000)
y_sim0 <- rbinom(n = 1000, size = 1, prob = plogis(sims@coef %*% t(as.matrix(sim0))))
mean(y_sim0)
sd(y_sim0)
quantile(y_sim0, c(.025, .975))

sim1 <- data.frame(intercept = 1, race1 = 1, age = mean(turnout$age),
                   educate = mean(turnout$educate), income = mean(turnout$income))
sims <- arm::sim(model1, n = 1000)
y_sim1 <- rbinom(n = 1000, size = 1, prob = plogis(sims@coef %*% t(as.matrix(sim1))))
mean(y_sim1)
sd(y_sim1)
quantile(y_sim1, c(.025, .975))

# Comparing both
mean(y_sim1) - mean(y_sim0)

# The simulation could also be done in Zelig
sim1 <- setx(model1, race1 = 0)
sim2 <- setx(model1, race1 = 1)
s.out <- sim(model1, x = sim1, x1 = sim2)
summary(s.out)
plot(s.out)

# Both first differences are -0.08, and that's the treatment effect :)
