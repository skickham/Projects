##################################
####Import Necessary Libraries####
##################################

library(data.table)
library(dplyr)
library(ggplot2)
library(devtools)
library(googleVis)
library(leaflet)
library(lubridate)
library(maps)
library(RColorBrewer)
library(RSQLite)
library(rsconnect)
library(tidyr)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(scales)

###################################
#####Set Up Data Frame#############
###################################

profiles = fread('/Users/skick/Desktop/shinyproj/profiles.csv', 
                 stringsAsFactors = FALSE)


#Take out essay options (for now)
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
summary(p)


#Convert all missing values to NA


p$income[p$income == -1]= NA       #income: Missings as -1

p = apply(p, 2,                    #all else: Missings as blank
          function(x) gsub("^$|^ $", NA, x))    
p = as.data.frame(p, stringsAsFactors = FALSE)


###################################
#####Graphs of Missing Data########
###################################


#count NAs by column: table of NAs

result = data.frame(Missing_Values = colSums(is.na(p)))
result2 = data.frame(Present_Values = colSums(!is.na(p)))

missing_values = 
  add_rownames(cbind(result, result2), "Field")      #bind the cols into single table with Field col instead of rownames

missing_values = 
  mutate(missing_values,        
       Total = Missing_Values + Present_Values,
       PropMissing = Missing_Values / Total,
       PropPres = Present_Values / Total)      #add a total column to check that it adds up to total obs


#graph Missing Values as proportion of total observations
missing_values = filter(missing_values, Missing_Values > 0)
ggplot(missing_values,
       aes(x = reorder(Field, -Missing_Values),
           y = PropMissing)) +
  geom_bar(stat = 'identity',
           aes(fill = Field)) +
  geom_text(data = missing_values,
            aes(label=paste0(round(PropMissing*100),"%"),
                y=PropMissing+0.012), 
            size=4,
            vjust = -.5)+ labs(x = 'Feature', y = "Percent Missing")

  scale_y_continuous(labels = percent) 
#graph Missing Values as proportion of all Missing Values

g = ggplot(p, aes(x = sex, y = as.numeric(income))) 

g + geom_boxplot(na.rm = TRUE)
g + geom_density(aes(color= job))
g + geom_freqpoly(aes(color = ethnicity))

#p %>% 
#  separate(col = ethnicity, sep = ',', )

# 
# p$asian = 0
# p$black = 0
# p$hispanic = 0
# p$indian = 0
# p$middleeastern = 0
# p$nativeamerican = 0
# p$pacificislander = 0
# p$white = 0
# p$other = 0
# p$multiethnic = 0
# p$singleethnic = 0
# p$doubleethnic = 0
# 
# p$asian[1] = grepl('asian',p$ethnicity[1])

for (i in 1:nrow(p)) {
  p$asian[i] = grepl('asian', p$ethnicity[i])*1
  p$black[i] = grepl('black', p$ethnicity[i])*1
  p$hispanic[i] = grepl('hispanic', p$ethnicity[i])*1
  p$indian[i] = grepl('indian', p$ethnicity[i])*1
  p$middleeastern[i] = grepl('middle', p$ethnicity[i])*1
  p$nativeamerican[i] = grepl('native', p$ethnicity[i])*1
  p$pacificislander[i] = grepl('pacific', p$ethnicity[i])*1
  p$white[i] = grepl('white', p$ethnicity[i])*1
  p$other[i] = grepl('other', p$ethnicity[i])*1
}

sum(p$asian)
sum(p$black)
sum(p$hispanic)
sum(p$indian)
sum(p$middleeastern)
sum(p$nativeamerican)
sum(p$pacificislander)
sum(p$white)
sum(p$other)


for (i in 1:nrow(p)) {
  p$multiethnic[i] = ifelse(sum(p[i, 22:29]) > 1, 1, 0)
}

sum(p[,22:29]) - sum(p$multiethnic)
#should be around 54266, the number of observations without missing ethnicities, 
#54140 because of other category which I didnt include in either sum


ggplot(p, aes(x = as.factor(multiethnic), 
              y = as.numeric(income))) + 
  geom_boxplot() +
  coord_trans(y = 'log10')


p2 = p

p2$ethnicity[p2$multiethnic == 1] = 'multiethnic'
p2$ethnicity[p2$ethnicity == 'asian, other'] = 'asian'
p2$ethnicity[p2$ethnicity == 'black, other'] = 'black'
p2$ethnicity[p2$ethnicity == 'hispanic / latin, other'] = 'hispanic / latin'
p2$ethnicity[p2$ethnicity == 'indian, other'] = 'indian'
p2$ethnicity[p2$ethnicity == 'middle eastern, other'] = 'middle eastern'
p2$ethnicity[p2$ethnicity == 'native american, other'] = 'native american'
p2$ethnicity[p2$ethnicity == 'pacific islander, other'] = 'pacific islander'
p2$ethnicity[p2$ethnicity == 'white, other'] = 'white'


View(p2)

ggplot(p2, aes(x = reorder(ethnicity, income), y = as.numeric(income))) + geom_boxplot(aes(color = ethnicity))

ggplot(p2, aes(x = ethnicity, 
               y = as.numeric(height))) + 
  geom_boxplot(aes(color = ethnicity))

ggplot(p2, aes(x = ethnicity, 
               y = as.numeric(age))) + 
  geom_boxplot(aes(color = ethnicity))


ggplot(p2, aes(x = smokes, 
               y = as.numeric(height))) + 
  geom_boxplot()


ggplot(p2, aes(x = orientation, 
               y = as.numeric(height))) + 
  geom_boxplot()

ggplot(p2, aes(x = orientation, 
               y = as.numeric(income))) + 
  geom_boxplot()

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = ethnicity), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = education), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = smokes), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = pets), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = offspring), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = body_type), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = diet), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = religion), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = drinks), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = sex), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = sign), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = drugs), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = status), position = 'fill')

ggplot(p2, aes(x = orientation)) + 
  geom_bar(aes(fill = age), position = 'fill')



#create shiny app to show percentages of missing values
  
sum(p2$orientation == 'bisexual')  
sum(p2$orientation == 'gay')  
sum(p2$orientation == 'straight')


###################################
##########Age Density##############
###################################
  
ggplot(p, aes(x = job, y = income)) + geom_boxplot(stat='identity')

  

suggplot(group_by(p,ethnicity), aes(x = ethnicity, y = height)) + geom_boxplot()

###################################
#########Height Density############
###################################




###################################
##########Age Density##############
###################################



###################################
##########Age Density##############
###################################

by_location = group_by(p, location) %>% 
  mutate(total = n()) %>% 
  arrange(desc(total))
View(by_location)

View(by_location %>% 
  summarise(smokerat = sum(smokes == 'no')/n()) %>% 
  arrange(desc(smokerat)))

View(p[p$drinks =='socially', ])

group_by(p, job)

ggplot(p, aes(x = body_type, y = height)) +
  geom_point(position = 'jitter') + 
  geom_boxplot()

nrow(p[p$income != -1, ])

nrow(p[p$orientation != 'straight', ])

nrow(p[p$religion != '', ])

nrow(p[p$drugs != '', ])

