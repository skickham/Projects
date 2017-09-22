############################################
######### Data Files to Create #############
############################################

#profiles = original csv
#p = profiles take away essays
#missing_values = a count of all the missing data by feature
#p2 = p with basic info for easier analysis, ie. ethnicity, religion, etc simplified
#p3 = display table in shinydashboard


############################################
###### Import Necessary Libraries ##########
############################################


library(tidyr)
library(tidyverse)
library(data.table)
library(dplyr)
library(ggplot2)



############################################
######### Upload CSV File ##################
############################################

profiles = fread('/Users/skick/Desktop/shinyproj/profiles.csv', 
                 stringsAsFactors = FALSE)


############################################
########### Create p.csv file ##############
############################################

p = profiles

p[, c('essay0', 
      'essay1', 
      'essay2', 
      'essay3', 
      'essay4', 
      'essay5', 
      'essay6',
      'essay7', 
      'essay8', 
      'essay9')] = NULL


#Convert all missing values to NA

p$income[p$income == -1]= NA                      #income: Missings as -1

p = apply(p, 2, function(x) gsub("^$|^ $", NA, x))      #all else: Missings as blank
    
p = as.data.frame(p, stringsAsFactors = FALSE)

#write it to a new csv file
write.csv(p, file='p.csv', row.names = FALSE)




############################################
######## Create missing_values.csv #########
############################################

#count NAs by column: table of NAs

result = data.frame(Missing_Values = colSums(is.na(p)))
result2 = data.frame(Present_Values = colSums(!is.na(p)))


#bind the cols into single table with Field col instead of rownames

missing_values = 
  add_rownames(cbind(result, result2), "Field") 


#add a total column to check that it adds up to total obs

missing_values = 
  mutate(missing_values,        
         Total = Missing_Values + Present_Values,
         PropMissing = Missing_Values / Total,
         PropPres = Present_Values / Total)     


#write it to a new csv file
write.csv(missing_values, file='missing_values.csv', row.names = FALSE)




############################################
############## Create p2.csv ###############
############################################

p2 = p



######### Ethnicity Simplified #############

for (i in 1:nrow(p2)) {
  p2$asian[i] = grepl('asian', p2$ethnicity[i])*1
  p2$black[i] = grepl('black', p2$ethnicity[i])*1
  p2$hispanic[i] = grepl('hispanic', p2$ethnicity[i])*1
  p2$indian[i] = grepl('indian', p2$ethnicity[i])*1
  p2$middleeastern[i] = grepl('middle', p2$ethnicity[i])*1
  p2$nativeamerican[i] = grepl('native', p2$ethnicity[i])*1
  p2$pacificislander[i] = grepl('pacific', p2$ethnicity[i])*1
  p2$white[i] = grepl('white', p2$ethnicity[i])*1
  p2$other[i] = grepl('other', p2$ethnicity[i])*1
}

for (i in 1:nrow(p2)) {
  p2$multiethnic[i] = ifelse(sum(p2[i, 22:29]) > 1, 1, 0)
}

sum(p2[,22:29]) - sum(p2$multiethnic)
#should be around 54266, the number of observations without missing ethnicities, 
#54140 because of other category which I didnt include in either sum


p2$ethnicity[p2$multiethnic == 1] = 'multiethnic'
p2$ethnicity[p2$ethnicity == 'asian, other'] = 'asian'
p2$ethnicity[p2$ethnicity == 'black, other'] = 'black'
p2$ethnicity[p2$ethnicity == 'hispanic / latin, other'] = 'hispanic / latin'
p2$ethnicity[p2$ethnicity == 'indian, other'] = 'indian'
p2$ethnicity[p2$ethnicity == 'middle eastern, other'] = 'middle eastern'
p2$ethnicity[p2$ethnicity == 'native american, other'] = 'native american'
p2$ethnicity[p2$ethnicity == 'pacific islander, other'] = 'pacific islander'
p2$ethnicity[p2$ethnicity == 'white, other'] = 'white'



######### Astrology Simplified #############

sort(unique(p2$sign))

p2$sign_serious = 0

for (i in 1:nrow(p2)) {
  if (grepl('matters', p2$sign[i])){
    p2$sign_serious[i] = 3
  } else {
    if (grepl('fun', p2$sign[i])) {
      p2$sign_serious[i] = 2
    } else {
      if (grepl('but', p2$sign[i])) {
        p2$sign_serious[i] = 1
      } else {
        p2$sign_serious[i] = 0
      }
    }
  } 
}

for (i in 1:nrow(p2)) {
  if (is.na(p2$sign[i])){
    p2$sign_serious[i] = NA
  }
}

p2$sign[grepl('aries', p2$sign)] = 'aries'
p2$sign[grepl('cancer', p2$sign)] ='cancer'
p2$sign[grepl('taurus', p2$sign)] = 'taurus'
p2$sign[grepl('gemini', p2$sign)] = 'gemini'
p2$sign[grepl('leo', p2$sign)] = 'leo'
p2$sign[grepl('sagittarius', p2$sign)] = 'sagittarius'
p2$sign[grepl('scorpio', p2$sign)] = 'scorpio'
p2$sign[grepl('virgo', p2$sign)] = 'virgo'
p2$sign[grepl('pisces', p2$sign)] = 'pisces'
p2$sign[grepl('libra', p2$sign)] = 'libra'
p2$sign[grepl('capricorn', p2$sign)] = 'capricorn'
p2$sign[grepl('aquarius', p2$sign)] = 'aquarius'

sort(unique(p2$sign))


######### Religion Simplified #############
sort(unique(p2$religion))

p2$religion_serious = 0

for (i in 1:nrow(p2)) {
  if (grepl('very', p2$religion[i])){
    p2$religion_serious[i] = 4
  } else {
    if (grepl('somewhat', p2$religion[i])) {
      p2$religion_serious[i] = 3
    } else {
      if (grepl('not too', p2$religion[i])) {
        p2$religion_serious[i] = 2
      } else {
        if (grepl('laughing', p2$religion[i])) {
          p2$religion_serious[i] = 1
        } else {
          p2$religion_serious[i] = 0
        }
      }
    }
  } 
}

for (i in 1:nrow(p2)) {
  if (is.na(p2$religion[i])){
    p2$religion_serious[i] = NA
  }
}


p2$religion[grepl('agnosticism', p2$religion)] = 'agnosticism'
p2$religion[grepl('atheism', p2$religion)] = 'atheism'
p2$religion[grepl('buddhism', p2$religion)] = 'buddhism'
p2$religion[grepl('catholicism', p2$religion)] = 'catholicism'
p2$religion[grepl('christianity', p2$religion)] = 'christianity'
p2$religion[grepl('hinduism', p2$religion)] = 'hinduism'
p2$religion[grepl('islam', p2$religion)] = 'islam'
p2$religion[grepl('judaism', p2$religion)] = 'judaism'
p2$religion[grepl('other', p2$religion)] = 'other'


sort(unique(p2$religion))


######### Education Simplified #############
sort(unique(p2$education))

p2$edu_complete = 3

for (i in 1:nrow(p2)) {
  if (grepl('grad', p2$education[i])){
    p2$edu_complete[i] = 2
  } else {
    if (grepl('work', p2$education[i])) {
      p2$edu_complete[i] = 1
    } else {
      if (grepl('drop', p2$education[i])) {
        p2$edu_complete[i] = 0
      } else {
        p2$edu_complete[i] = 3
      }
    }
  } 
}


for (i in 1:nrow(p2)) {
  if (is.na(p2$education[i])){
    p2$edu_complete[i] = NA
  }
}



length(p2$edu_complete[p2$edu_complete == 0 & !is.na(p2$edu_complete)]) 

length(p2$education[p2$education == 'dropped out of high school' & !is.na(p2$education)]) #102 not finished high school


p2$education[grepl('university', p2$education)] = 'college/university'
p2$education[grepl('law', p2$education)] = 'law school'
p2$education[grepl('med', p2$education)] = 'med school'
p2$education[grepl('space', p2$education)] = 'space camp'
p2$education[grepl('high', p2$education)] = 'high school'
p2$education[grepl('masters', p2$education)] = 'masters'
p2$education[grepl('ph.d', p2$education)] = 'ph.d'
p2$education[grepl('two', p2$education)] = 'two-year college'

sort(unique(p2$education))



######### Offspring Simplified #############
sort(unique(p2$offspring))

p2$offspring[grepl('has', p2$offspring)] = 'has kid(s)'
p2$offspring[grepl('wants', p2$offspring)] = 'wants kid(s)'
p2$offspring[grepl('might', p2$offspring)] = 'unsure'
p2$offspring[grepl('doesn&rsquo;t want', p2$offspring)] = 'not want kid(s)'
p2$offspring[grepl('have', p2$offspring)] = 'has no kid(s)'

sort(unique(p2$offspring))



######### Diet Simplified #############
sort(unique(p2$diet))

p2$diet[grepl('anything', p2$diet)] = 'anything'
p2$diet[grepl('halal', p2$diet)] = 'halal'
p2$diet[grepl('kosher', p2$diet)] = 'kosher'
p2$diet[grepl('vegan', p2$diet)] = 'vegan'
p2$diet[grepl('vegetarian', p2$diet)] = 'vegetarian'
p2$diet[grepl('other', p2$diet)] = 'other'


ggplot(p2, aes(x = diet)) + geom_bar()
sort(unique(p2$diet))


######### Pets Simplified #############
sort(unique(p2$pets))

p2$dogs = NA

p2$dogs[grepl('likes dogs', p2$pets)] = 'likes'
p2$dogs[grepl('dislikes dogs', p2$pets)] = 'dislikes'
p2$dogs[grepl('has dogs', p2$pets)] = 'has'

p2$cats = NA

p2$cats[grepl('likes cats', p2$pets)] = 'likes'
p2$cats[grepl('dislikes cats', p2$pets)] = 'dislikes'
p2$cats[grepl('has cats', p2$pets)] = 'has'

sort(unique(p2$cats))
sort(unique(p2$dogs))

length(p2$cats[p2$cats == 'has' & !is.na(p2$cats)]) +
  length(p2$cats[p2$cats == 'likes' & !is.na(p2$cats)]) +
  length(p2$cats[p2$cats == 'dislikes' & !is.na(p2$cats)]) +
  length(p2$cats[is.na(p2$cats)])

length(p2$dogs[p2$dogs == 'has' & !is.na(p2$dogs)]) + 
  length(p2$dogs[p2$dogs == 'likes' & !is.na(p2$dogs)]) +
  length(p2$dogs[p2$dogs == 'dislikes' & !is.na(p2$dogs)]) +
  length(p2$cats[is.na(p2$dogs)])





#write it to a new csv file
write.csv(p2, file = 'p2.csv', row.names = FALSE)

str(p2)



############################################
########## Create p3.csv file ##############
############################################
p3 = p2[ , -c(11,15,20, 22:29)]

p3 = p3 %>% 
  select(Gender = sex, 
         Age = age,
         Location = location,
         Status = status,
         Orientation = orientation,
         Ethnicity = ethnicity,
         Religion = religion,
         Religion.Serious = religion_serious,
         Sign = sign,
         Sign.Serious = sign_serious,
         Height = height,
         Body.Type = body_type,
         Education = education,
         Job = job,
         Income = income,
         Offspring = offspring,
         Dogs = dogs,
         Cats = cats,
         Smokes = smokes,
         Drinks = drinks,
         Drugs = drugs,
         Diet = diet)

write.csv(p3, file = '/Users/skick/Desktop/shinyproj/shinyApp_Project/p3.csv', row.names = FALSE)

str(p3)



############################################
############## Essays ######################
############################################


# essay0- My self summary
# essay1- What I'm doing with my life
# essay2- I'm really good at
# essay3- The first thing people usually notice about me
# essay4- Favorite books, movies, show, music, and food
# essay5- The six things I could never do without
# essay6- I spend a lot of time thinking about
# essay7- On a typical Friday night I am
# essay8- The most private thing I am willing to admit
# essay9- You should message me if...

essays = profiles %>% 
  select(Self.Summary = essay0,
         Message.Me = essay9,
         First.Thing = essay3,
         Favorites = essay4,
         Friday.Night = essay7,
         Thoughts = essay6,
         Cant.Do.Without = essay5,
         Private = essay8)

essays = cbind(p3, essays)

write.csv(essays, file = '/Users/skick/Desktop/shinyproj/essays.csv', row.names = FALSE)




###########################
#### WORD CLOUDS ##########
###########################


library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

essaycorpus = Corpus(VectorSource(profiles$essay5[profiles$ethnicity == 'white']))

essaycorpus <- tm_map(essaycorpus, PlainTextDocument)
essaycorpus <- tm_map(essaycorpus, toSpace, '&amp')
essaycorpus <- tm_map(essaycorpus, toSpace, 'ilink')
essaycorpus <- tm_map(essaycorpus, toSpace, '<br />')
essaycorpus <- tm_map(essaycorpus, toSpace, '/<(.*?)>/')
essaycorpus <- tm_map(essaycorpus, toSpace, 'friends')
essaycorpus <- tm_map(essaycorpus, toSpace, 'family')
essaycorpus <- tm_map(essaycorpus, removePunctuation)
essaycorpus <- tm_map(essaycorpus, removeWords, stopwords('english'))
essaycorpus <- tm_map(essaycorpus, stemDocument)

essaycorpus = Corpus(VectorSource(essaycorpus))

wordcloud(essaycorpus,
          max.words = 150,
          random.order = FALSE,
          scale = c(8, .2),
          colors = brewer.pal(7, 'Blues') )

findFreqTerms(dtm, lowfreq = 4)
?toSpace






nrow(filter(p3, Education == 'space camp' & Gender == 'm'))    # 71% male
nrow(filter(p3, Education == 'space camp' & Drugs == 'sometimes'))   # 23% sometimes use drugs vs. 13% otherwise
nrow(filter(p3, Education == 'space camp' & 
              Gender == 'f' & Offspring == 'not want kid(s)'))   # 14% vs. 7% in gen pop
nrow(filter(p3, Education == 'space camp'))
1196/1683





ggplot(arrange(missing_values, desc(PropMissing)), aes(x = Field, y = PropMissing)) + geom_bar(stat= 'identity')
