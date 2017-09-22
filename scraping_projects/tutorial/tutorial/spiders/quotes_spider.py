import scrapy
from tutorial.items import TutorialItem


class QuotesSpider(scrapy.Spider):
    name = "quotes"
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
            'http://quotes.toscrape.com/page/1/',
            'http://quotes.toscrape.com/page/2/',
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    

    def parse(self, response):
        for quote in response.css('div.quote'):
            text = quote.css('span.text::text').extract_first()
            author = quote.css('small.author::text').extract_first()
            tags = quote.css('div.tags a.tag::text').extract()
            
            text = self.verify(text)
            author = self.verify(author)
            tags = self.verify(tags)

            item = TutorialItem()
            item['text'] = text
            item['author'] = author
            item['tags'] = tags

            yield item 


        page = response.url.split("/")[-2]
        filename = 'quotes-%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Saved file %s' % filename)

# import scrapy


# class QuotesSpider(scrapy.Spider):
#     name = "quotes"
#     start_urls = [
#         'http://quotes.toscrape.com/page/1/',
#         'http://quotes.toscrape.com/page/2/',
#     ]

#     def parse(self, response):
#         page = response.url.split("/")[-2]
#         filename = 'quotes-%s.html' % page
#         with open(filename, 'wb') as f:
#             f.write(response.body)