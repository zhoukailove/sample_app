class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  #def index
  #
  #end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      p "=========="
      @feed_items = []
      p "==========1111111"
      render 'static_page/home'
      p "==========2222222"
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path

  end

  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    #@micropost = current_user.microposts.find(params[:id])
    @micropost = current_user.microposts.find(params[:id])
  rescue
    redirect_to root_path
  end
end
