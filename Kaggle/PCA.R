library(data.table)
setwd("C:/Users/skick/Desktop/Kaggle")
df = fread('df_important.csv')
View(df)

df$V1 = NULL
df$price_doc = NULL
df$price_doc_log = NULL
df$price_doc_log10 = NULL

sapply(df, class)
df$timestamp = NULL
df$sub_area = NULL
df$dataset = NULL
df$id = NULL

df <- sapply(df, as.numeric)

######################################


green = c('green_part_500', 'green_part_1000','green_part_1500',
         'green_part_2000','green_part_3000','green_part_5000')

prom = c('prom_part_500','prom_part_1000','prom_part_1500',
        'prom_part_2000','prom_part_3000','prom_part_5000')

office = c('office_count_500','office_sqm_500','office_count_1000',
          'office_sqm_1000','office_count_1500', 'office_sqm_1500',
          'office_count_2000','office_sqm_2000','office_count_3000',
          'office_sqm_3000','office_count_5000','office_sqm_5000')

# shopping malls
trc = c('trc_count_1000', 'trc_count_1500', 'trc_count_2000', 'trc_count_3000', 
       'trc_count_500', 'trc_count_5000', 'trc_sqm_1000', 'trc_sqm_1500',
       'trc_sqm_2000', 'trc_sqm_3000', 'trc_sqm_500', 'trc_sqm_5000', 'trc_count_1000', 'trc_sqm_1000')


church = c('big_church_count_500', 'church_count_500', 'mosque_count_500',
          'big_church_count_1000', 'church_count_1000', 'mosque_count_1000',
          'big_church_count_1500', 'church_count_1500', 'mosque_count_1500',
          'big_church_count_3000', 'church_count_3000', 'mosque_count_3000',
          'big_church_count_5000', 'church_count_5000', 'mosque_count_5000',
          'big_church_count_2000', 'church_count_2000', 'mosque_count_2000')


sport = c('sport_count_500','sport_count_1000','sport_count_2000', 
         'sport_count_5000','sport_count_1500','sport_count_3000')

leisure = c('leisure_count_500','leisure_count_3000','leisure_count_1000',
           'leisure_count_1500','leisure_count_2000','leisure_count_5000')

market = c('market_count_500','market_count_5000', 'market_count_2000',
          'market_count_1000','market_count_1500','market_count_3000')    


cafe_price = c('cafe_sum_500_min_price_avg', 'cafe_sum_500_max_price_avg',
              'cafe_avg_price_500', 'cafe_sum_1000_min_price_avg','cafe_sum_1000_max_price_avg', 
              'cafe_avg_price_1000', 'cafe_sum_1500_min_price_avg', 'cafe_sum_1500_max_price_avg', 
              'cafe_avg_price_1500', 'cafe_sum_2000_min_price_avg', 'cafe_sum_2000_max_price_avg', 
              'cafe_avg_price_2000', 'cafe_sum_3000_min_price_avg', 'cafe_sum_3000_max_price_avg',
              'cafe_avg_price_3000',  'cafe_sum_5000_min_price_avg', 'cafe_sum_5000_max_price_avg',
              'cafe_avg_price_5000','cafe_count_5000_price_high')


cafe_count = c('cafe_count_500', 'cafe_count_500_na_price',
              'cafe_count_500_price_500', 'cafe_count_500_price_1000',
              'cafe_count_500_price_1500', 'cafe_count_500_price_2500',
              'cafe_count_500_price_4000', 'cafe_count_500_price_high', 'cafe_count_1000', 
              'cafe_count_1000_na_price', 'cafe_count_1000_price_500',
              'cafe_count_1000_price_1000', 'cafe_count_1000_price_1500',
              'cafe_count_1000_price_2500', 'cafe_count_1000_price_4000',
              'cafe_count_1000_price_high','cafe_count_1500',
              'cafe_count_1500_na_price',
              'cafe_count_1500_price_500', 'cafe_count_1500_price_1000',
              'cafe_count_1500_price_1500', 'cafe_count_1500_price_2500',
              'cafe_count_1500_price_4000', 'cafe_count_1500_price_high', 'cafe_count_2000', 
              'cafe_count_2000_na_price', 'cafe_count_2000_price_500',
              'cafe_count_2000_price_1000', 'cafe_count_2000_price_1500',
              'cafe_count_2000_price_2500', 'cafe_count_2000_price_4000',
              'cafe_count_2000_price_high', 'cafe_count_3000', 'cafe_count_3000_na_price',
              'cafe_count_3000_price_500', 'cafe_count_3000_price_1000',
              'cafe_count_3000_price_1500', 'cafe_count_3000_price_2500',
              'cafe_count_3000_price_4000', 'cafe_count_3000_price_high','cafe_count_5000',
              'cafe_count_5000_na_price', 'cafe_count_5000_price_500',
              'cafe_count_5000_price_1000', 'cafe_count_5000_price_1500',
              'cafe_count_5000_price_2500', 'cafe_count_5000_price_4000',
              'cafe_count_5000_price_high')

price = c('price_doc', 'price_doc_log', 'price_doc_log10') 



######################################


# 
# library(reshape2)
# x <- reshape2::melt(as.matrix(df))
# dcast(x, Var1 ~ value, fun.aggregate = length, value.var="value")


colnames(df)
library(psych)
for i in colnames(df):
  print i

cafe = df[, c('cafe_count_5000_price_high', 
       'cafe_count_1500_price_high', 
       'cafe_count_2000_price_2500', 
       'cafe_count_5000', 
       'cafe_count_1500_price_500', 
       'kremlin_km', 'floor', 
       'oil_chemistry_raion',
       'build_year',
       )]


class(df)
df

fa.parallel(cafe, #The data in question
            fa = "pc", #Display the eigenvalues for PCA.
            n.iter = 100) #Number of simulated analyses to perform.
abline(h = 1)

pc_cafe = principal(cafe, #The data in question.
                    nfactors = 1,
                    rotate = "none") #The number of PCs to extract.
pc_cafe

factor.plot(pc_cafe,
            labels = colnames(pc_cafe)) #Add variable names to the plot.
