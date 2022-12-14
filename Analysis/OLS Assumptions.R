library(ggplot2)
library(stargazer)
library(dplyr)

citylm <- lm(Rating ~ sumang + rating_seen + rating_seen*sumang + review_seen + review_seen*sumang +
               sumant + rating_seen*sumant + review_seen*sumant + sumjoy + rating_seen*sumjoy + review_seen*sumjoy +
               sumsad + rating_seen*sumsad + review_seen*sumsad + sumdis + rating_seen*sumdis + review_seen*sumdis +
               sumfear + rating_seen*sumfear + review_seen*sumfear + sumtrust + rating_seen*sumtrust + review_seen*sumtrust +
               sumsurp + rating_seen*sumsurp + review_seen*sumsurp
             , data = citydata)

citylm
stargazer(citylm)
summary(citylm)
### REMOVE influential cases (cook's D)
library(olsrr)
ols_plot_cooksd_chart(citylm, print_plot = T)

cooksD <- cooks.distance(citylm)
influential <- cooksD[(cooksD > (4 / (195640 - 26)))]
influential

names_of_influential <- names(influential)
outliers <- citydata[names_of_influential,]

citydata_out <- citydata %>% anti_join(outliers)

citylm2 <- lm(Rating ~ sumang + rating_seen + rating_seen*sumang + review_seen + review_seen*sumang +
               sumant + rating_seen*sumant + review_seen*sumant + sumjoy + rating_seen*sumjoy + review_seen*sumjoy +
               sumsad + rating_seen*sumsad + review_seen*sumsad + sumdis + rating_seen*sumdis + review_seen*sumdis +
               sumfear + rating_seen*sumfear + review_seen*sumfear + sumtrust + rating_seen*sumtrust + review_seen*sumtrust +
               sumsurp + rating_seen*sumsurp + review_seen*sumsurp
             , data = citydata_out)


###ASSUMPTION 1: Linearity
plot(citylm2, which = 1)


###ASSUMPTION 2: independence of residual values (Durbin-Watson test)
library(lmtest)
dwtest(formula = citylm2, alternative = "two.sided")


###ASSUMPTION 3: No Multicollinearity (variance of inflation (VIF))
library(car)

citycor <- citydata_out[ ,c('Rating', 'ang', 'ant', 'dis', 'joy', 'sad'
                                      , 'fear', 'trust', 'surp', 'review_seen', 'rating_seen')]
cormat <- cor(citycor, use = 'complete.obs')
cormat <- round(cormat, digits = 4)
cormat

write.csv(cormat, "C:\\Users\\Bovan\\OneDrive\\Documents\\MA Thesis\\Thesis\\cormat.csv")
###ASSUMPTION 4: Homoskedacity and no Autocorrelation (plot variance of residuals) = Will be violated (Breusch pagan test)
ols_test_breusch_pagan(citylm2)
plot(citylm2, which = 3)

###ASSUMPTION 5 Normality of residuals
hist(citylm2$residuals)
plot(citylm2, which = 2)





#####All plots
plot(citylm, which = 1)
plot(citylm, which = 2)
plot(citylm, which = 3)
plot(citylm, which = 5)

par(mfrow=c(2,2))
plot(citylm)