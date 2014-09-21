require 'open-uri'
require 'nokogiri'
require 'time'
require 'i18n'
require 'index_shop_job'
require 'index_account_job'
require 'destroy_shop_job'
require 'le_logger'

class ShopQueuer
  include Resque::Plugins::UniqueJob
  
  @queue = :search_queue
  def self.perform(url)
    uri = URI.parse(url)
    site = open(url)
    site = Nokogiri::HTML(site)
    threads = site.css('#view_forum_table tr')
    return false if threads.empty?
    hydra = Typhoeus::Hydra.new(max_concurrency: 10)
    threads.each do |thread|
      next if thread['class'] == 'heading'
      # See if shop exists in database, create it if it doesn't
      thread_no = "#{uri.scheme}://#{uri.host}" + thread.css('div.thread_title div.title a').first['href']
      unless Shop.exists?(thread: thread_no) then
      	shop = Shop.new
      	shop.thread = thread_no
      else
      	shop = Shop.find_by_thread(thread_no)
      end
      # Open the shop url
      url = shop.thread
  	  request = Typhoeus::Request.new(url, :followlocation => true)
      request.on_complete do |response|
        if response.success?
          @result = Nokogiri::HTML(response.body)

          # Update seller name
          seller = @result.css('div.posted-by span.post_by_account a').first
          if seller.nil?
            LOGGER.info "Found seller with no profile link -- skipped"
            next
          end
          region = shop.thread.include?('garena') ? Region.find_by_name('Garena') : Region.find_by_name('Global')
          shop.seller = Seller.find_or_create_by(account_name: seller.content, region: region)
          shop.seller.save

          if shop.seller.ign == '**Pending**' or shop.seller.updated_at < 1.day.ago then
            Resque.enqueue(IndexAccountJob, shop.seller.id)
          end
          
          # Check last post date
          last_post_date = thread.css('td.last_post span.post_date').first
          last_post_date = Time.parse(last_post_date.content.sub("on ",'') + ' UTC') if last_post_date

          # Update last updated
          last_updated = @result.css('div.last_edited_by').first
          if last_updated.nil? then
            last_updated = @result.css('div.posted-by span.post_date').first.content + ' UTC'
          else
            last_updated = I18n.transliterate(last_updated.content).sub(/^Last edited by .+ on /, '') + ' UTC'
          end
          begin
            last_updated = Time.strptime(last_updated, "%B %e, %Y %l:%M %P %Z")
            if last_post_date and last_post_date > last_updated
              shop.last_updated = last_post_date.utc
            else
              shop.last_updated = last_updated.utc
            end
          rescue
            LOGGER.error "Couldn't parse time stamp -- #{last_updated} -- shop thread #{shop.thread}"
            next
          end

          # If shop hasn't been updated in a long time, remove it and continue
          if shop.last_updated < 2.weeks.ago then
            Resque.enqueue(DestroyShopJob, shop.id) unless shop.id.nil?
            next
          end

          # Check if shop was indexed since last update, if so then skip
          if !shop.last_indexed.nil? and (shop.last_updated < shop.last_indexed) then 
            shop.save
            next
          end
          
          shop.save if shop.changed?
          Resque.enqueue(IndexShopJob, shop.id)
          
          shop = nil
        else
          LOGGER.error "Unsuccessful request: #{request.inspect}"
        end
      end
      hydra.queue request
    end
    hydra.run
    
    hydra = nil
    threads = nil
    site = nil
    
  end
end