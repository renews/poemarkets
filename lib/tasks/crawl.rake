require 'forum_crawler'
require 'reindex_shops_job'
require 'verify_job'
require 'update_currency_ratios_job'

task "crawl:first" => :environment do
  League.all.each do |league|
      league.forums.each do |forum|
        ForumCrawler.crawl(forum.id, 1)
      end
  end
end

task "crawl:all" => :environment do
  League.all.each do |league|
    league.forums.each do |forum|
      ForumCrawler.crawl(forum.id)
    end
  end
end

task "crawl:all:limit", [:limit] => :environment do |t, args|
  League.all.each do |league|
      league.forums.each do |forum|
        ForumCrawler.crawl(forum.id, args[:limit].to_i)
      end
  end
end

task "crawl:league:first", [:league] => :environment do |t, args|
  league = League.find_by_name(args[:league])
  league.forums.each do |forum|
    ForumCrawler.crawl(forum.id, 1)
  end
end

task "crawl:league:all", [:league] => :environment do |t, args|
  league = League.find_by_name(args[:league])
  league.forums.each do |forum|
    ForumCrawler.crawl(forum.id)
  end
end

task "crawl:league:limit", [:league, :limit] => :environment do |t, args|
  league = League.find_by_name(args[:league])
  league.forums.each do |forum|  
    ForumCrawler.crawl(forum.id, args[:limit].to_i)
  end
end

task "shops:destroy:old" => :environment do
  Shop.where('last_updated < ?', 2.weeks.ago).find_each do |shop|
    Resque.enqueue(DestroyShopJob, shop.id)
  end
end

task "items:verify" => :environment do
  Resque.enqueue(ReindexShopsJob)
end

task "items:verify:all" => :environment do
  Resque.enqueue(ReindexShopsJob, false)
end

task "ratios:update" => :environment do
  Resque.enqueue(UpdateCurrencyRatiosJob)
end