class Seller < ActiveRecord::Base
  
  has_many :shops, dependent: :destroy
  belongs_to :region
  
  before_create :set_uuid
  
  def self.online
    self.where(online: true)
  end
  
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
  
  def online?
    self.online
  end
  
  def offline?
    !self.online
  end

  def account_url
    self.region.name == 'Garena' ? "http://web.poe.garena.com/account/view-profile/#{self.account_name}" : "http://www.pathofexile.com/account/view-profile/#{self.account_name}"
  end

end
