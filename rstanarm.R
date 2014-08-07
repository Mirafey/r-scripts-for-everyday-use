# This script enables you to run a full Bayesian model with Stan by using the
# convenience functions stanlm/stanglm. Here: https://github.com/stan-dev/rstanarm
# Install from GitHub

require(devtools)
install_github("rstanarm", "stan-dev")

# Load necessary packages

require(rstanarm) # Stan models with glm syntax
require(ggmcmc)   # MCMC graphs: http://xavier-fim.net/packages/ggmcmc/
require(foreign)  # read dta files

# Load Fearon and Laitin's (2003) data set (http://web.stanford.edu/group/ethnic/publicdata/repdata.zip)
# and recode onset

fearon <- read.dta("/home/sussa/Desktop/repdata.dta")
fearon$onset <- ifelse(fearon$onset >= 1, 1, fearon$onset)

# Logit in Stan

m1 <- stanglm(onset ~ warl + gdpenl + lpopl1 + lmtnest + ncontig + 
              Oil + nwstate + instab + polity2l + ethfrac + relfrac,
              family = binomial(link="logit"), data = fearon)

# Results: displaying the median, 95% and 90%

print(m1, probs = c(0.025, 0.05, 0.50, 0.95, 0.975), digits_summary=3)
traceplot(m1, inc_warmup = FALSE)

# Model 2

m2 <- stanglm(onset ~ warl + gdpenl + lpopl1 + lmtnest + ncontig + 
                    Oil + nwstate + instab + anocl + deml + ethfrac + relfrac,
                    family = binomial(link="logit"), data = fearon)
traceplot(m2, inc_warmup = FALSE)

print(m2, probs = c(0.025, 0.05, 0.50, 0.95, 0.975), digits_summary=3)

# Graphs

model1 <- ggs(m1) # saves the MCMC file in a new object
ggs_density(model1) + theme_minimal()
ggs_compare_partial(model1) + theme_minimal()
ggs_caterpillar(model1) + theme_grey()

model2 <- ggs(m2) # saves the MCMC file in a new object
ggs_density(model2) + theme_minimal()
ggs_compare_partial(model2) + theme_minimal()
ggs_caterpillar(model2) + theme_minimal()


