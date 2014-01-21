class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #使用 sign_in 方法实现登录操作，然后转向用户的资料页面
      sign_in user
      redirect_to user
    else
      flash[:error] = 'Invalid email/password combination'
      render 'new'
    end


  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
