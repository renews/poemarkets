class DestroyShopJob
  include Resque::Plugins::UniqueJob

  @queue = :destroy_shop_queue

  def self.perform(shop_id)
    shop = Shop.find(shop_id)
    shop.items.destroy_all
    shop.destroy
  end
end