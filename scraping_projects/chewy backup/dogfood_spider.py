
import scrapy
from chewy.items import ChewyItem


class DogFoodSpider(scrapy.Spider):
    name = "dog_food"

    def verify(self, content):     #content is whatever you extracted
            if isinstance(content, list):     #when would it give a list????
                 if len(content) > 0:
                     content = content[0]     #first element
                     # convert unicode to str
                     return content.encode('ascii','ignore')
                 else:        #empty string
                     return ""
            else:
                # convert unicode to str
                return content.encode('ascii','ignore')


    def start_requests(self):
        urls = [
            'https://www.chewy.com/s?rh=c%3A288%2Cc%3A332&page=1', 
            'https://www.chewy.com/s?rh=c%3A288%2Cc%3A332&page=2'
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)


    def parse(self, response):
    	products = response.xpath('//article[@class = "product-holder  cw-card cw-card-hover"]')  
    	# tested len(products) in shell to see tht it matched the 36 items on the page

    	for product in products:
    		#brand = product..strip()
    		product_name = product.xpath('.//h2/strong/text()').extract_first().strip()
    		product_description = product.xpath('.//h2/text()').extract()[1].strip()
    		cost = product.xpath('.//p[@class = "price"]/strong/text()').extract_first().strip()
    		old_cost = product.xpath('.//span[@class = "price-old"]/text()').extract_first().strip()
    		#rating = product.xpath('.').extract_first().strip()
    		no_reviews = product.xpath('.//p[@class = "rating item-rating"]/span/text()').extract_first().strip()

    		#verify
    		#brand = self.verify(brand)
    		product_name = self.verify(product_name)
    		product_description = self.verify(product_description)
    		cost = self.verify(cost)
    		old_cost = self.verify(old_cost)
    		#rating = self.verify(rating)
    		no_reviews = self.verify(no_reviews)

    		#yield item
    		item = ChewyItem()
    		#item['brand'] = brand 
    		item['product_name'] = product_name
    		item['product_description'] = product_description
    		item['cost'] = cost
    		item['old_cost'] = old_cost
    		#item['rating'] = rating
    		item['no_reviews'] = no_reviews

    		yield item






        page = response.url.split("=")[-1]
        filename = 'dogfood-%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Saved file %s' % filename)


# import scrapy


# class QuotesSpider(scrapy.Spider):
#     name = "quotes"
#     start_urls = [
#         'https://www.chewy.com/s?rh=c%3A288%2Cc%3A332&page=1', 
#         'https://www.chewy.com/s?rh=c%3A288%2Cc%3A332&page=2'
#     ]

#     def parse(self, response):
#         page = response.url.split("/")[-2]
#         filename = 'quotes-%s.html' % page
#         with open(filename, 'wb') as f:
#             f.write(response.body)