class Admin::LeaguesController < Admin::AdminController
  
  def index
    @leagues = League.all
  end
  
  def destroy
    @league = League.find(params[:id])
    @league.drop_view
    @league.destroy
    
    flash[:notice] = "League deleted successfully"
    
    respond_to do |format|
      format.html { redirect_to admin_leagues_path }
    end
  end
  
  def new
    @league = League.new
  end
  
  def create
    @league = League.new(league_params)
    
    if @league.save
      
      @league.create_view
      @league.populate_ratios
      
      flash[:notice] = "League added successfully"

      respond_to do |format|
        format.html { redirect_to admin_leagues_path }
      end
    else
      flash.now[:error] = "Could not save league"
      render action: "new"
    end
  end
  
  private
  
  def league_params
    params.require(:league).permit(:name, :region_id)
  end
  
end
