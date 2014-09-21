require 'capybara'
#require 'capybara/poltergeist'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = "http://web.poe.garena.com"
Capybara.default_wait_time = 5

class CheckGarenaMessagesJob
  include Resque::Plugins::UniqueJob
  
  @queue = :check_messages_queue
  def self.perform
    page = Capybara::Session.new(:selenium)
    
    uri = "/private-messages/inbox"
    
    page.visit(uri)
    sleep 10
    page.fill_in 'username', :with => "[removed]"
    page.fill_in 'userpass', :with => "[removed]"
    page.click_on 'Login'
    sleep 5
    page.all('table.pm-list tr').count.times do
      page.all('table.pm-list tr').each do |row|
        status = row.find('td.status')
        if status.has_text?('Unread')
          row.click_link(row.find('div.subject a').text)
          sleep 5
          seller = page.first('td.message-details span.profile-link a')
          seller = Seller.find_or_create_by(account_name: seller.text, region: Region.find_by_name('Garena'))
          puts seller.inspect
          page.click_on('Reply')
          page.fill_in 'Subject', :with => "Your personal PoE Markets link"
          page.fill_in 'Content', :with => "Hi, #{seller.account_name}. Thanks for using PoE Markets.\n\n Your personal seller link is " + ENV['ROOT_URL']+"/seller/#{seller.uuid}" + "\n\n Use this page to control your seller presence on PoE Markets, and don't share this link with anyone else.\n\nCheers,\nPoE Markets"
          page.click_on('Submit')
          break
        end
      end
    end
  end
end