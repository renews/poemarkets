class Admin::ForumsController < Admin::AdminController
  
  def index
    @forums = Forum.all
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    
    flash[:notice] = "Forum deleted successfully"
    
    respond_to do |format|
      format.html { redirect_to admin_forums_path }
    end
  end
  
  def new
    @forum = Forum.new
  end
  
  def create
    @forum = Forum.new(forum_params)
    
    if @forum.save
      
      flash[:notice] = "Forum added successfully"

      respond_to do |format|
        format.html { redirect_to admin_forums_path }
      end
    else
      flash.now[:error] = "Could not save forum"
      render action: "new"
    end
  end
  
  private
  
  def forum_params
    params.require(:forum).permit(:url, :league_id)
  end
  
end
