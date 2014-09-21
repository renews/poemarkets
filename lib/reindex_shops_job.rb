require 'verify_shop_job'

class ReindexShopsJob
  include Resque::Plugins::UniqueJob

  @queue = :administration_queue

  def self.perform
    Shop.where("last_indexed < ?", 2.days.ago).find_each do |shop|
      if shop.last_updated < 2.weeks.ago then
        Resque.enqueue(DestroyShopJob, shop.id) unless shop.id.nil?
      else
        Resque.enqueue(VerifyShopJob, shop.id) unless shop.id.nil?
      end
    end
  end

end