import scrapy
from chewy.items import ChewyItem


class DogFoodSpider(scrapy.Spider):
    name = "toys"
    allowed_urls = ['https://www.chewy.com/']
    start_urls = ['https://www.chewy.com/s?rh=c%3A325%2Cc%3A326&page=1', 'https://www.chewy.com/s?rh=c%3A288%2Cc%3A315&page=1', 'https://www.chewy.com/b/perches-toys-967', 'https://www.chewy.com/s?rh=c%3A977%2Cc%3A1005&page=1']
            # maybe: https://www.chewy.com/b/food-332


    def verify(self, content):     #content is whatever you extracted
        if content is None:
            return ""
        elif isinstance(content, list):     #when would it give a list????
             if len(content) > 0:
                 content = content[0]     #first element
                 # convert unicode to str
                 return content.encode('ascii','ignore')
             else:        #empty string
                 return ""
        else:
            # convert unicode to str
            return content.encode('ascii','ignore')



    def parse(self, response):    # parse for init page in start_urls
        # products = response.xpath('//article[@class = "product-holder  cw-card cw-card-hover"]')  
        # # tested len(products) in shell to see tht it matched the 36 items on the page

        # for product in products:
            # product_name = product.xpath('.//h2/strong/text()').extract_first().strip()
            # product_description = product.xpath('.//h2/text()').extract()[1].strip()
            # cost = product.xpath('.//p[@class = "price"]/strong/text()').extract_first().strip()
            # old_cost = product.xpath('.//span[@class = "price-old"]/text()').extract_first().strip()
            # rating = product.xpath('.//p[@class="rating item-rating"]//img/@src').extract_first().strip().split('-')[1].split('.')[0]
            # no_reviews = product.xpath('.//p[@class = "rating item-rating"]/span/text()').extract_first().strip()
        page = response.xpath('//p[@class="results-count"]/text()').extract_first().split(' ')[0].split('(')[1]
        page = int(page)
        page = (page + 35)/36
        page = str(page)
        category = response.xpath('//div[@class="results-header__title"]//h1/text()').extract_first().strip()
        url_list = response.xpath('//article[@class="product-holder  cw-card cw-card-hover"]//a/@href').extract()
        page_url = ['https://www.chewy.com' + l for l in url_list]


        for url in page_url:
            yield scrapy.Request(url, callback=self.parse_top, meta={'category' : category, 'page':page})
#, meta={'product_name':product_name,'product_description': product_description,'cost': cost,'old_cost': old_cost,'rating': rating,'no_reviews': no_reviews}
        next_page = str(response.xpath('//a[@class="btn btn-white btn-next"]/@href').extract_first())
        next_page = 'https://www.chewy.com/' + next_page
        yield scrapy.Request(next_page, callback=self.parse)



    def parse_top(self, response):
        category = response.meta['category']
        page = response.meta['page']
        product_name = response.xpath('//div[@id="brand"]/a/text()').extract_first().strip()
        product_description = response.xpath('//div[@id="product-title"]/h1/text()').extract_first().strip()
        cost = str(response.xpath('//div[@id="pricing"]//p[@class ="price"]/span/text()').extract_first()).strip()
        old_cost = str(response.xpath('//*[@id="pricing"]//li[@class = "list-price"]/p[2]/text()').extract_first()).strip()
        size = str(response.xpath('//*[@id="variation-Size"]/div/span/text()').extract_first()).strip()
        rating = str(response.xpath('//*[@id="ugc-section"]//span[@itemprop = "ratingValue"]/text()').extract_first()).strip()
        no_reviews = str(response.xpath('//*[@id="ugc-section"]//span[@itemprop = "reviewCount"]/a/text()').extract_first()).strip().split(' ')[0]
        percent_rec = response.xpath('//*[@id="ugc-section"]//span[@class="progress-radial__text--percent"]/text()').extract_first()


        # verify
        category = self.verify(category)
        page = self.verify(page)
        product_name = self.verify(product_name)
        product_description = self.verify(product_description)
        cost = self.verify(cost)
        old_cost = self.verify(old_cost)
        size = self.verify(size)
        rating = self.verify(rating)
        no_reviews = self.verify(no_reviews)
        percent_rec = self.verify(percent_rec)


        k = response.xpath('//*[@id="attributes"]/ul/li/div/text()').extract()
        k = [item.strip() for item in k]
        k = [x.encode('ascii', 'ignore').decode('ascii') for x in k]
        k = [str(x) for x in k]
        k = [x.lower().replace(' ', '_') for x in k]
        ll = zip(k[::2], k[1::2])
        ll = dict(ll)


        #yield item
        item = ChewyItem()
        item['product_name'] = product_name
        item['product_description'] = product_description
        item['cost'] = cost
        item['old_cost'] = old_cost
        item['rating'] = rating
        item['no_reviews'] = no_reviews
        item['size'] = size
        item['percent_rec'] = percent_rec
        item['category'] = category
        item['page'] = page

        for i, j in ll.items():
            item[i] = j

        yield item



        
        # k = [i+' : ' + j for i,j in zip(k[::2],k[1::2])]


        # page = response.url.split("=")[-1]
        # filename = 'dogfood-%s.html' % page
        # with open(filename, 'wb') as f:
        #   f.write(response.body)
        # self.log('Saved file %s' % filename)


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