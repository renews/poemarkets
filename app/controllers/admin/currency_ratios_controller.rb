class Admin::CurrencyRatiosController < Admin::AdminController
  
  def index
    @ratios = CurrencyRatio.all
  end
  
  def destroy
    @ratio = CurrencyRatio.find(params[:id])
    @ratio.destroy
    
    flash[:notice] = "Ratio deleted successfully"
    
    respond_to do |format|
      format.html { redirect_to admin_currency_ratios_path }
    end
  end
  
  def new
    @ratio = CurrencyRatio.new
  end
  
  def create
    @ratio = CurrencyRatio.new(ratio_params)
    
    if @ratio.save
      
      flash[:notice] = "Ratio added successfully"

      respond_to do |format|
        format.html { redirect_to admin_currency_ratios_path }
      end
    else
      flash.now[:error] = "Could not save ratio"
      render action: "new"
    end
  end
  
  private
  
  def ratios_params
    params.require(:ratio).permit(:currency_id, :league_id, :chaos_ratio)
  end
  
end
