class UserSessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:email])
  	if user && user.authenticate(params[:password])
  	session[:user_id] = user.id
  	flash[:success] = "You are now logged in!"
  	redirect_to todo_lists_path	
  else
  	flash[:error] = "Login failed!  Please check your details and try again."
  	render action: 'new'
  end
 end
end
