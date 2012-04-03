class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :destroy]
  before_filter :find_user, :only => [:edit, :update, :destroy]
  before_filter :require_self, :only => [:edit, :update, :destroy]

  def find_user
    @user = User.find(params[:id])
  end
  
  def require_self
    redirect_to :root unless @user == current_user
  end
    
  def welcome
    @user = User.new
  end
  
  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save_without_session_maintenance
        @user.reload

        format.html { redirect_to(root_path, :notice => '<span class="icon yes">Du bekommst eine E-Mail mit Bestätigungslink an ' + @user.email + '</span>') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(root_path, :notice => '<span class="icon yes">Daten gespeichert</span>') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    #current_user_session.destroy
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
end
