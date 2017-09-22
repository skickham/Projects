# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html


class TutorialPipeline(object):
   	def __init__(self):
		self.filename = 'Quotes.txt'      
                # name of txt doc to print all info

	def open_spider(self, spider):
		self.file = open(self.filename, 'wb')    
        # open and allow to write (and binary)

	def close_spider(self, spider):
		self.file.close()

	def process_item(self, item, spider):
		line = '\t'.join(item.values()) + '\n'       
                # tab separate each value in the 
                # dictionary and then make a newline
                # commas in some movie titles, 
                # so saving to csv isnt a great idea
		self.file.write(line)
		return item   # why return item?

