#################
### OpenIntro ###
### Chapter 1 ###
#################

### Installing and loading packages

# Hello! :) Today we'll talk about the first chapter of the OpenIntro Stat book.
# (website: http://www.openintro.org/stat/textbook.php)
# The authors have kindly provided an R package with almost all 
# data sets used in the book. Since the package is available on CRAN
# (The Comprehensive R Archive Network), you can install it very easily.

# Just type

install.packages("openintro")

# Then load the package

library(openintro)

### Loading a data set

# At page 3 the authors talk about the "email50" data set
# Let's take a look at it. We use the data() command to read data sets that are
# inside R packages. The R object will have the same name of the data set.

data(email50)    # load the data set
str(email50)     # structure of the data
summary(email50) # summarises the data 

# On page 4 they introduce the "county" data set

data(county)

# Explore it! Try also the head() and tail() commands, which respectively show the
# first and last five observations of the data set. If you want to know more about
# this (or any) command in R, type ?head

?head

### Graphs: scatterplot, histograms and boxplots

## Scatterplot

# Later at page 7 they present a scatterplot showing fed_spend against poverty.
# Let's code it here too using both the "graphics" and the "ggplot2" packages in R.
# If you don't have ggplot2, install it using the command you learned 
# above: install.packages(ggplot2)
# First with use the graphics package (you don't have to load it, it's in R already).
# The variables are written as dataset$variable, "main" is the title, and 
# xlab and ylab are the titles for the x and y axes, respectively. You can also
# omit the x = and y =, I just let it here for you to know what goes where.

plot(x = county$poverty, y = county$fed_spend, type = "p", #for "points"
     main = "Scatterplot of Fed spending per capita and Poverty",
     xlab = "poverty",
     ylab = "fed_spend")

# With ggplot2, using the qplot ("quick plot") function. If you add two variables,
# ggplot2 assumes you want a scatterplot.

library(ggplot2)

qplot(poverty, fed_spend, data = county) +
        ggtitle("Scatterplot of Fed spending per capita and Poverty") +
        xlab("poverty") +
        ylab("fed_spend")

# You can also add a line of best fit to the model. Let's now replicate the
# scatterplot on page 20 and adding a line to the points. We add the option 
# geom_smooth(method = "lm") to ggplot2, where lm stands for linear model.
# If you want a LOESS regression line, just change the option inside the 
# parentheses. Let's check both cases:

qplot(num_char, line_breaks, data = email50) +
        xlab("Number of Characters (in thousands)") +
        ylab("Number of Lines") + 
        geom_smooth(method = "lm")

qplot(num_char, line_breaks, data = email50) +
        xlab("Number of Characters (in thousands)") +
        ylab("Number of Lines") + 
        geom_smooth(method = "loess")

# You can also apply data transformations as described on pages 30-33. Taking the
# log of num_chart and the square root of line_breaks, for instance:

qplot(log(num_char), sqrt(line_breaks), data = email50) +
        xlab("Number of Characters (log)") +
        ylab("Number of Lines (square root)") + 
        geom_smooth(method = "loess")

## Histogram

# Replicating the histogram on page 24:

hist(email50$num_char, main = "", xlab = "Number of Characters (in thousands)",
     col = "lightblue", breaks = seq(from = 0, to = 70, by = 10))

# Where col = is the colour of the histogram, and breaks are the line breaks.
# I used another command, seq(), which stands for sequence. In this case, the 
# sequence goes from 0 to 70 by intervals of 10. You could type any number with
# c(), which stands for concatenate. You should use c() any time you want to 
# include more than a single number into an object or command.

hist(email50$num_char, main = "", xlab = "Number of Characters (in thousands)",
     col = "lightblue", breaks = c(0,20,40,60,80,100,120))

# It is also very easy to do a histogram with ggplot2. If you just write one
# variable on the command it will guess you want a histogram. 

qplot(num_char, data = email50)

# You can also add some options and change the number of bins in the graph.
# You may also change the theme that ggplot2 uses. You can choose amongst
# theme_bw(), theme_minimal(), theme_classic(), theme_gray(), and theme_light()

qplot(num_char, data = email50, binwidth=0.5) + 
        xlab("Number of Characters (in thousands)") +
        ylab("Count") +
        ggtitle("Histogram") +
        theme_bw()

# At page 28 the authors discuss the uses of the boxplot. 
# Let's plot a few boxplots here too!

boxplot(email50$num_char, main = "Boxplot",
        xlab = "Number of Characters (in thousands)")

# With ggplot2, using number (as a factor with three levels) and line_breaks

qplot(as.factor(number), line_breaks, data = email50, geom = "boxplot") + 
        ggtitle("Boxplot") +
        xlab("Number of Characters (in thousands)") +
        ylab("Number of Lines") + 
        theme_grey()

### Sampling

# At page 10 they talk about sampling. You can sample in R too!
# Check the sample() command
?sample

# Let's sample 15 cases of the "state" variable in the county data set and 
# save in the object samp1. We want sampling without replacement.
samp1 <- sample(county$state, 15, replace = FALSE)
samp1

### Correlations

# They also talk about association at page 12. The first measure we use to assess
# if two variables are associated is the "correlation coefficient". For continuous
# variables, we generally use the Pearson correlation. You can read about it on 
# Wikipedia: http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient
# It goes from -1 (perfect negative correlation) to +1 (positive), with zero indicating
# no correlation at all. Let's check it with cor.test()
 
cor.test(county$poverty, county$fed_spend)

# The test shows that the true correlation is not zero (the coefficient is
# statistically significant), but the value is actually very close to zero (~0.06).

### Categorical data

# The easiest way to create a contingency table is to use table() and tabulate 

tabulate(email50$number)
table(email50$spam, email50$number)

# You can test the association between both variables with a Chi-squared test

chisq.test(email50$spam, email50$number)

# A nice way of visualising categorical data is through mosaicplot(). We use it with
# the table command. We can also recode the levels so the graph is more intuitive.

mosaicplot(table(email50$spam, email50$number), 
           main = "Mosaic Plot", 
           xlab = "Spam", ylab = "Number", 
           col = c(2,3,4))
