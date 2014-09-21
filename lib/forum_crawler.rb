require 'open-uri'
require 'nokogiri'
require 'shop_queuer'

class ForumCrawler
  def self.full_crawl(forum_id)
    self.crawl(forum_id, false)
  end
  
  def self.first_page_crawl(forum_id)
    self.crawl(forum_id, 1)
  end
  
  def self.crawl(forum_id, page_limit=false)
    forum = Forum.find(forum_id)
    site = Nokogiri::HTML(open(forum.url))
    page_limit = site.xpath('//*[@id="mainContainer"]/div[2]/div[2]/div[1]/a[6]').text.to_i unless page_limit
    page = 1
    loop do
      url = forum.url + '/page/' + page.to_s
      Resque.enqueue(ShopQueuer, url)
      break if page >= page_limit
      page += 1
    end
  end
end