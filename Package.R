#install.packages("ggplot2")
#install.packages("readxl")


library(ggplot2)
library(readxl)


level_of_significance <- 0.05

daily_data <- read_excel("C:\\Users\\SUGUNAN\\OneDrive\\Documents\\R Programming\\Package\\dependencies\\daily_gold_rate.xls")
annual_data <- read_excel("C:\\Users\\SUGUNAN\\OneDrive\\Documents\\R Programming\\Package\\dependencies\\annual.xls")

data2 <- data.frame(Year = annual_data$Year,Rate = annual_data$INR,Date= annual_data$Date)
data <- data.frame(Year = daily_data$Year,Rate = daily_data$INR,Date= daily_data$Date)

regression_model <- lm(Rate ~ Year,data=data)


annual_plot <- ggplot(data2 , aes( x = Date , y = Rate)) +
  geom_point() +
  ggtitle("Gold Rate") +
  labs(
    x="Years",
    y="Gold Rate per pound",
    title="Scatter Plot for Gold Rate Prediction Model ( On Annual Basis )"
  ) +
  geom_smooth(method="lm",se=F,fullrange=TRUE,size=0.8) 


daily_plot <- ggplot(data , aes( x = Date , y = Rate)) +
  geom_point() +
  ggtitle("Gold Rate") +
  labs(
    x="Years",
    y="Gold Rate per pound",
    title="Scatter Plot for Gold Rate Prediction Model ( On Daily Basis )"
  ) +
  geom_smooth(method="lm",se=F,fullrange=TRUE,size=0.8)

print(annual_plot)
print(daily_plot)
cat("\014")

regression_function <- function(x)
{
  regression_model$coefficients[1]+x*regression_model$coefficients[2]
}


cat("\n\t\t- Gold Rate Prediction Model ( On Daily Basis ) -\n\n")
cat("     -> Regression Line : y =",regression_model$coefficients[1],"+",regression_model$coefficients[2],"x\n")
cat("     -> The Data Set Dates Ranges from 1985-01-01 to 2023-10-06 !\n")
cat("     -> The Level of Significance : ",level_of_significance,"\n")



sample_summary <- summary(regression_model)
r_squared_value <- sample_summary$r.squared
p_value <- sample_summary$coefficients[1,'Pr(>|t|)']

cat("\n\n\n  Goodness of Fit : \n")
cat("\n     -> Null Hypothesis : The Regression model is a Good Fit.")
cat("\n     -> Alternative Hypothesis : The Regression model is a Poor Fit.")
cat("\n     -> Decision for Goodness of Fit : ")

if(round(r_squared_value) == 1 )
{
  cat("\n\t    * The R - Squared Value : ",r_squared_value)
  cat("\n\t    * Since R - Squared Value is close to 1")
  cat("\n\t    * There are no proper evidence to reject the Null Hypothesis.")
  cat("\n\t    * The Regression model is a Good Fit, and a large portion of the variance is explained.\n")
}else
{
  cat("\n\t    * The R - Squared Value : ",r_squared_value)
  cat("\n\t    * Since R - Squared Value is close to 0")
  cat("\n\t    * Reject the Null Hypothesis.")
  cat("\n\t    * The Regression model is a Poor Fit, and it explains very little of the variance.")
}

cat("\n\n\n  Statistical Significance : \n")
cat("\n     -> Null Hypothesis : The coefficients are statistically SIGNIFICANT.")
cat("\n     -> Alternative Hypothesis : The coefficients are statistically INSIGNIFICANT.")
cat("\n     -> Decision for Significance : ")

if(p_value < level_of_significance)
{
  cat("\n\t    * The P - Value : ",p_value)
  cat("\n\t    * There are no proper evidence to reject the Null Hypothesis.")
  cat("\n\t    * The coefficients are statistically SIGNIFICANT\n")
}else
{
  cat("\n\t    * The P - Value : ",p_value)
  cat("\n\t    * Reject the Null Hypothesis.")
  cat("\n\t    * The coefficients are statistically INSIGNIFICANT\n")
}


cat("\n\n  The Summary of the Regression Model : \n")
print(summary(regression_model))



valid_year <- function(year)
{
  if (is.numeric(year) && length(year) == 1 && year > 0 && year == round(year)) 
  {
    TRUE
  }else
  {
    FALSE
  }
}

while(TRUE)
{
  cat("\n\t\t NOTE : Enter 0 to terminate the input !\n")
  cat("\n\t Enter a Year to predict its value: ")
  user_input <- as.numeric(scan(what = character(), n = 1, quiet = TRUE))
  
  if(valid_year(user_input))
  {
    prediction <- predict(regression_model, newdata = data.frame(Year = as.double(user_input)))
    cat("\t According to the Regression Model\n")
    cat("\t The Gold Rate might reach ₹",prediction,"at the year of", user_input,"\n")
    break
  }else if(user_input==0)
  {
    break
  }else
  {
    cat("NOTE : Please Enter a Valid input !\n")
  }
}


