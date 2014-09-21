require 'digest'

class SearchController < ApplicationController
  
  before_filter :get_item_count
  
  def index
    @chaos = Currency.find_by_name('Chaos Orb')
    @tip = File.readlines("#{Rails.root}/lib/data/tips.txt").sample
    @params = Hash.new
    if params[:slug]
      @search = Search.find_by_slug(params[:slug])
      if @search.nil?
        redirect_to '/search'
        return
      end
      @params = JSON.parse(@search.params)
    else
      @params["page"] = ""
      @params["order"] = ""
      @params["normalize_buyouts"] = 'yes'
    end
    expires_in 1.hour, :public => true
    
    if stale?(@search)
      respond_to do |format|
        format.html
      end
    end
  end
  
  def results
    expires_in 5.minutes, :public => true
    unless params[:slug]
      @slug = Digest::MD5.hexdigest(params.to_json)[0..7]
      @page = params[:page].to_i if params[:page]
    else
      @slug = params[:slug]
      @page = 1
    end
    @search = Search.find_by(slug: @slug)
    @search = Search.create(slug: @slug, params: params.to_json) if @search.nil?
    @chaos = Currency.find_by_name('Chaos Orb')
    @resistance_mods = ResistanceMod.all.map { |r| r.name }
    
    @params = params
    params["league"] = "Standard" if params["league"].nil? or params["league"].blank?
    @league = League.find_by_name(params["league"])
    
    @items = @search.find_items(@page, @league)
    if @page and @page > 1
      render partial: "results_page", layout: false
    else
      @count = @items.length
      render "results", layout: false
    end
  end
end
