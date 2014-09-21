class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def get_item_count
    @item_count = ActiveRecord::Base.connection.execute("SELECT reltuples FROM pg_class WHERE relname = 'items'")
  end
end
