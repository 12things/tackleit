class MessagesController < ApplicationController
  before_filter :require_user, :except => [:new, :create, :thankyou]

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
      format.json  { render :json => @message.to_json(:include => :company) }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    url = URI.parse(params[:url]) if params[:url]
    redirect_to root_path and return if params[:format]!='widget' && params[:url].blank?
    
    if !current_user
      session[:email] = params[:email]
      session[:url] = params[:url]
      session[:website_email] = params[params[:website_email]]
    end
    
    @website = Website.find_or_create_by_host(url.host) if url
    if params[:website_email]
      @website.email = params[:website_email] 
      @website.save
    end
    @message = Message.new(:url => params[:url], :website_email => params[:website_email])

    respond_to do |format|
      format.html { redirect_to @website }
      format.widget
    end
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    url = URI.parse(@message.url)
    @message.path = url.path
    
    if current_user
      user = current_user
      session[:email] = nil
      session[:url] = nil
      session[:website_email] = nil
    else
      user = User.find_or_create_by_email(@message.email)
      session[:email] = user.email
      session[:url] = @message.url
      session[:website_email] = @message.email
    end
    
    @message.user = user
    
    @website = Website.find_or_create_by_host(url.host)  
    @website.email = @message.website_email if @website.email.blank? && ! @message.website_email.blank?

    if user.active? && !current_user
      if user.active?
        @message.errors.add(:base, "Du musst dich erst mit dieser E-Mail-Adresse einloggen")

        respond_to do |format|
          format.html { redirect_to new_user_session_path; return }
          format.widget { render :action => "new"; return }
        end
      elsif !current_user
        @message.errors.add(:base, "Du musst erst den Link in der E-Mail klicken")

        respond_to do |format|
          format.html { redirect_to @website; return }
          format.widget { render :action => "new"; return }
        end
      end
      
    end
    
    @website.messages << @message
    @website.save    
    
    respond_to do |format|
      if @message.save
        format.html { redirect_to(@website, :notice => '<span class="icon yes">Message wurde angelegt</span>') }
        format.widget { redirect_to(thankyou_message_path(@message, :format => 'widget')) }
        format.json  { render :json => @message.to_json }
      else
        format.html { redirect_to @website }
        format.widget { render :action => "new" }
        format.json  { render :json => @message.errors.to_json }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @website = @message.website
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(@website) }
      format.xml  { head :ok }
    end
  end
end
