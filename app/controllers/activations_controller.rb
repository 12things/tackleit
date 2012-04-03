class ActivationsController < ApplicationController
  before_filter :require_no_user

  def create
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?

    if @user.activate!
      UserSession.create(@user, false) # Log user in manually
      redirect_to edit_user_path(@user), :notice => '<span class="icon yes">Dein Konto wurde aktiviert!</span>'
    else
      render :action => :new
    end
  end
end
