class Admin::AdminController < ApplicationController
  
  before_filter :authenticate, :get_item_count

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'admin' && password == 'password'
    end
  end
  
  def index
    
  end
  
end
