###Step 1 Tokenization and Normalization

library(tidytext)
library(tidyverse)
library(tm)
library(dplyr)
library(textstem)
###dataset 

city <- bostonmerge
city$city <- 'Boston'

city <- city %>%
  rename("review_seen"="...1")

city <- city[!(city$review_seen > 200),]

city = subset(city, select = -c(2, 7))

city <- city %>%
  mutate(review_id=row_number())

#Remove numbers from text
city$review <- removeNumbers(city$Review)

#Tokenize the words (unnest also removes punctuation and lowercases all words)
city_word <- city %>%
  unnest_tokens("word", "review")

###Step 3 Stop Words
city_word2 <- city_word %>%
  anti_join(stop_words)

### Step 4 Lemmatization
city_word2$lemma <- lemmatize_words(city_word2$word)

city_final = subset(city_word2, select = -c(Review))
