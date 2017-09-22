# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy
from scrapy import Item, Field


class BudgetItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    RDate = Field()
    Title = Field()
    PBudget = Field()
    DomesticG = Field()
    WorldwideG = Field()
    pass
