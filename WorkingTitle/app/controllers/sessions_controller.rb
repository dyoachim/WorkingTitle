class SessionsController < ApplicationController

  def login
    @user = User.find_by_email(params[:email])
    if @user.authenticate(params[:password])
      session[:current_user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect '/'
    end
  end

  def logout
    session[:current_user_id] = nil
    redirect_to '/'
  end
end
