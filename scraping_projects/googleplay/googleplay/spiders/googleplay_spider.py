# -*- coding: utf-8 -*-
import scrapy
from scrapy import Spider
from googleplay.items import GoogleplayItem


class GoogleSpider(Spider):
    name = 'google_spider'
    allowed_urls = ['https://play.google.com/store']
    start_urls = ['https://play.google.com/store/apps/top']

    
    
#//*[@id="mw-content-text"]/tr

    def verify(self, content):     #content is whatever you extracted
        if isinstance(content, list):     #when would it give a list????
            if len(content) > 0:
                content = content[0]     #first element
                    # convert unicode to str
                return content.encode('ascii','ignore')
            else:        
                return ""
        else:
            #convert unicode to str
            return content.encode('ascii','ignore')

        
        
        
        
    def parse(self, response):
        links = response.xpath('//a[@class = "title-link id-track-click"]/@href').extract()     # python list
        for link in links:
            new_url = 'https://play.google.com' + link    # concat new links together
            yield scrapy.Request(new_url, callback = self.parse_list)

    def parse_list(self, response):
        app_list = response.xpath('//div[@class = "cluster-heading"]/h2/text()').extract_first()
        app_links = response.xpath('//a[@class = "card-click-target"]/@href').extract()
        links = list(set(links))
        for link in app_links:
            app_url = 'https://play.google.com' + link
            yield scrapy.Request(app_url, callback = self.parse_app,
                                meta = {'app_list':app_list})        # add the meta to give the list of lists???
    
    def parse_app(self, response):
        app_list = response.meta['app_list']    #grab the meta using the dictionary key  #we're piggy backing the info from before)
        app_list = self.verify(app_list)
        
        name = response.xpath('//div[@class = "id-app-title"]/text()').extract_first()
        name = self.verify(name)
        
        company = response.xpath('//a[@class="document-subtitle primary"]/span/text()').extract_first()
        company = self.verify(company) 
        
        category = response.xpath('//a[@class= "document-subtitle category"]/span/text()').extract_first()
        category = self.verify(category)
        
        avg_score = response.xpath('//div[@class = "score"]/text()').extract_first()
        avg_score = self.verify(avg_score)
        
        reviews = response.xpath('//div[@class="single-review"]')    # save as selected list   idky
        
        for review in reviews:
            content = review.xpath('.//div[@class = "review-body with-review-wrapper"]').extract()
            content = ''.join(content).strip()
            content= self.verify(content)
            
            rating = review.xpath('.//div[@class = "tiny-star star-rating-non-editable-container"]/@aria-label').extract_first()   
            rating = self.verify(rating)
            # the ".//" takes the current directory of reviews and looks for any div child with that class
            
            
            #each review is an item so this is where you create the dictionary
            item = GoogleplayItem()
            item['app_list'] = app_list
            item['name'] = name
            item['company'] = company
            item['category'] = category
            item['avg_score'] = avg_score
            item['content'] = content
            item['rating'] = rating

            yield item

        
        
        
        #### Test in scrapy shell for selected list:
        #reviews[10].xpath('.//div[@class="review-body with-review-wrapper"]/text()').extract()
        # index the reviews
        # extract not extract first in case there's mmore than one element