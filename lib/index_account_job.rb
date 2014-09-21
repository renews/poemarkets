require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'

class IndexAccountJob 
  include Resque::Plugins::UniqueJob
  
  @queue = :account_queue
  
  def self.perform(seller)
    seller = Seller.find(seller)
    if seller.region.name == 'Garena'
      url = 'http://web.poe.garena.com/account/view-profile/'+seller.account_name
    else
      url = 'http://www.pathofexile.com/account/view-profile/'+seller.account_name
    end
    profile = Nokogiri::HTML(open(URI.encode(url), allow_redirections: :safe).read, nil, 'utf-8')
    ign = profile.css('div.characters div.profile-character div.character-info span.characterName')
    unless ign.first.nil?
      ign = ign.first.text
    else
      ign = '(!) Private'
    end
    seller.ign = ign
    challenge = profile.css('div.challenge-level img.achievement')
    seller.challenge_icon = challenge.first["src"] unless challenge.first.nil?
    account_id = profile.xpath('/html/body/script[5]').first.content.scan(/accountID: \d+/).first
    seller.account_id = account_id.sub('accountID: ', '') if account_id
    seller.updated_at = Time.now
    seller.save
    
    seller = nil
    profile = nil
    challenge = nil
    ign = nil
  end
end