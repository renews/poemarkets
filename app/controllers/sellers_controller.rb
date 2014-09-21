class SellersController < ApplicationController
  
  before_filter :get_item_count
  skip_before_filter :verify_authenticity_token
  
  def index
    @seller = Seller.find_by_uuid(params[:uuid])
    if @seller.nil?
      flash[:error] = "We couldn't find a seller with that unique ID. Please try sending a forum PM to poemarkets AND bumping your shop."
      redirect_to root_url
    end
  end
  
  def status
    @seller = Seller.find_by_uuid(params[:uuid])
    @seller.online = true
    @seller.online_until = Time.now + params[:duration].to_i.hour
    @seller.save
    
    redirect_to '/seller/'+@seller.uuid and return
  end
  
  def offline
    @seller = Seller.find_by_uuid(params[:uuid])
    @seller.online = false
    @seller.online_until = 0
    @seller.save
    
    redirect_to '/seller/'+@seller.uuid and return
  end
  
  def updateign
    @seller = Seller.find_by_uuid(params[:uuid])
    @seller.ign = params[:preferredign]
    @seller.save
    
    redirect_to '/seller/'+@seller.uuid and return
  end
end
