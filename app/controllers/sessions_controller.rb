class SessionsController < ApplicationController
  def new
    #debugger
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user # log the user in and redirect to the user's show page.
      else
        message = "Account not Activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end 
    else
      flash.now[:danger] = 'Invalid email/password combo'
    render 'new'
    end 
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
