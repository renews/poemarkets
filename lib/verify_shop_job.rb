require 'index_shop_job'

class VerifyShopJob < IndexShopJob
  @queue = :verify_queue
  def self.perform(shop_id)
    super
  end
end