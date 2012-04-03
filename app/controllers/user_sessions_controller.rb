class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
    respond_to do |format|
      format.html
      format.widget
    end
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      @user_session.user.reset_perishable_token!
      
      respond_to do |format|
        format.html { redirect_to root_path }
        format.widget { redirect_to new_message_path(:format => params[:format]) }
      end
      
    else
      respond_to do |format|
        format.html { render :action => :new }
        format.widget { render :action => :new }
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_to root_path(:format => params[:format])
  end
end
