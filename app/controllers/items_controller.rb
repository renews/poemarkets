require 'verify_job'

class ItemsController < ApplicationController
  def verify
    
    msg = VerifyJob.perform(params[:id])

    respond_to do |format|
      format.json { render :json => msg}
    end
    
  end
  
  def similar_names
    respond_to do |format|
      format.json { render :json => Item.similar_names(params[:term]).to_json }
    end
  end
  
  def base_types
    unless params[:item_type_id].blank?
      @item_types = []
      if params[:item_type_id].include?(',')
        params[:item_type_id].split(',').each do |type|
          @item_types << ItemType.find(type)
        end
      end
      @item_types << ItemType.find(params[:item_type_id])
    else
      @item_types = ItemType.all
    end
    
    @base_types = []
    
    @item_types.each do |type|
      type.base_types.each do |btype|
        @base_types << btype
      end
    end
    
    respond_to do |format|
      format.json { render :json => @base_types.to_json }
    end
  end
end
