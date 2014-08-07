# Using the sample function:
# sample(x, size, replace = FALSE, prob = NULL)
# sample.int(n, size = n, replace = FALSE, prob = NULL)
# sample.int is a bare interface in which both n and size must be supplied as integers.

?sample

outcomes <- c("Danilo", "Mira", "Nobody")
sample100 <- sample(outcomes, 100, replace = TRUE, prob = c(.2,.5,.3))
head(sample100)
table(sample100)

# Using sample and a loop:

outcomes1 <- 0:10
sample200 <- rep(NA, 200)

for(i in seq(along=sample200)){
  # Samples of size 100
  samp <- sample(outcomes1, 100, replace = TRUE)
  # Takes the mean of such samples
  sample200[i] <- mean(samp) 
}

summary(sample200)
hist(sample200)

# Loop for squaring values, comparing with ifelse:

values <- rnorm(1000, 10, 5)
squared <- rep(NA, 1000)
squared1 <- rep(NA, 1000)

for(i in seq(along=squared1)){
  if (values[i] <= 5) {
    squared1[i] <- -1
  }  else {
    squared1[i] <- values[i]^2
  }
}
squared <- ifelse(values <= 5, -1, values^2)

hist(squared)
df <- data.frame(values, squared, squared1)
View(df)
