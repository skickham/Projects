from scrapy import Spider
from budget.items import BudgetItem

class BudgetSpider(Spider):
    name = 'budget_spider'
    allowed_urls = ['http://www.the-numbers.com/']
    start_urls = ['http://www.the-numbers.com/movie/budgets/all']
    
    def verify(self, content):     #content is whatever you extracted
        if isinstance(content, list):     #when would it give a list????
            if len(content) > 0:
                content = content[0]     #first element
                # convert unicode t
                return content.encode('ascii','ignore')
            else:        #empty string
                return ""
        else:
            # convert unicode to str
            return content.encode('ascii','ignore')
    
    def parse(self, response):
        rows = response.xpath('//*[@id="page_filling_chart"]/center/table/tr')
        #patterns = [xpath patts]
        
        for i in range(1, len(rows), 2):
            RDate = rows[i].xpath('./td[2]/a/text()').extract_first()
            Title = rows[i].xpath('./td[3]/b/a/text()').extract_first()
            PBudget = rows[i].xpath('./td[4]/text()').extract_first()
            DomesticG = rows[i].xpath('./td[5]/text()').extract_first()
            WorldwideG = rows[i].xpath('./td[6]/text()').extract_first()
            
            RDate = self.verify(RDate)
            Title = self.verify(Title)
            PBudget = self.verify(PBudget)
            DomesticG = self.verify(DomesticG)
            WorldwideG = self.verify(WorldwideG)
            
            item = BudgetItem()
            item[ 'RDate' ] = RDate
            item[ 'Title' ] = Title
            item[ 'PBudget' ] = PBudget
            item[ 'DomesticG' ] = DomesticG
            item[ 'WorldwideG' ] = WorldwideG
            yield item
            