
library(tidyr)
library(tidyverse)
library(data.table)
library(dplyr)
library(ggplot2)

food = fread('/Users/skick/Desktop/chewy/chewyfood.csv', 
                 stringsAsFactors = FALSE)
food$lifestage = strsplit(food$lifestage, ',_')

food$dimensions = NULL




food$breed_size = strsplit(food$breed_size, ',_')


food = food[, c("item_number", "category", "page", "brand", 
              "product_name", "product_description", "no_reviews", "rating", 
              "percent_rec", "cost", "old_cost", "size", "weight", "breed_size",
             "lifestage", "food_form", "food_texture", "special_diet",
             "supplement_form", "fish_type", "small_pet_type", "reptile_type", "bird_type", "made_in")]


food$old_cost = replace(food$old_cost, food$old_cost=="None", NA)
food$size = replace(food$size, food$size =="None", NA)
food$weight = replace(food$weight, food$weight =="", NA)
food$no_reviews = replace(food$no_reviews, food$no_reviews=="None", 0)
food$breed_size = replace(food$breed_size, food$breed_size=="character(0)", NaN)
food$lifestage = replace(food$lifestage, food$lifestage=="character(0)", NA)

food$cost = gsub('\\$', '', food$cost)
food$old_cost = gsub('\\$', '', food$old_cost)
food$sale = round((as.numeric(food$old_cost) - as.numeric(food$cost))/as.numeric(food$old_cost) * 100, 2)


### weights
sum(is.na(food$weight))   #5349
for (i in 1:nrow(food)) {
  if (grepl('pound', food$weight[i])){
    food$weight_in_pounds[i] = food$weight[i]
  }
}


#### vis


ggplot(food, aes(x = rating)) + geom_density()
ggplot(food, aes(x = percent_rec)) + geom_density()
ggplot(food, aes(x = sale)) + geom_density()
ggplot(food, aes(x = category, y = as.numeric(cost))) + geom_boxplot()
ggplot(food, aes(x = category, y = as.numeric(sale))) + geom_boxplot()
ggplot(food, aes(x = category, y = as.numeric(old_cost))) + geom_boxplot()
ggplot(food, aes(x = category, y = as.numeric(weight))) + geom_boxplot()
ggplot(food, aes(x = category, y = as.numeric(no_reviews))) + geom_boxplot() + ylim(0, 250)
ggplot(food, aes(x = category, y = as.numeric(rating))) + geom_boxplot()
ggplot(food, aes(x = category, y = as.numeric(percent_rec))) + geom_boxplot()










