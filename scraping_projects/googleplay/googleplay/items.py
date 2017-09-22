# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class GoogleplayItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    content = scrapy.Field()
    name = scrapy.Field()
    company = scrapy.Field()
    category = scrapy.Field()
    avg_score = scrapy.Field()
    rating = scrapy.Field()
    app_list = scrapy.Field()