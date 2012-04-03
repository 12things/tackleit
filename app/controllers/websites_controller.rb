require 'open-uri'

class WebsitesController < ApplicationController
  before_filter :require_user, :except => [:show, :imprint]

  # GET /websites/1
  # GET /websites/1.xml
  def show
    @website = Website.find(params[:id])
    @message = Message.new(:url => @website.url, :website_email => @website.email)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @website }
    end
  end

  # GET /websites/new
  # GET /websites/new.xml
  def new
    @website = Website.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @website }
    end
  end

  # POST /websites
  # POST /websites.xml
  def create
    @website = Website.new(params[:website])

    respond_to do |format|
      if @website.save
        format.html { redirect_to(edit_user_path(current_user), :notice => '<span class="icon yes">Website wurde angelegt</span>') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # POST /websites/claim
  def claim
    host = params[:host].gsub(/^^http:\/\//, '')
    @website = Website.find_by_host(host) || Website.new({:host => host})

    respond_to do |format|
      format.html
    end
  end
  
  # POST /websites/1/verify
  def verify
    @website = Website.find(params[:id])
    
    unless @website.verified?
      @doc = Nokogiri::HTML(open(@website.url))
    
      @doc.xpath('//head/meta[@name="microid"]').each do |microid|
        if microid[:content]==@website.microid(current_user, true)
          @website.verified = true
          @website.company = current_user.company
          @website.save
          flash[:notice] = '<span class="icon yes">Die Website wurde verifiziert</span>'
          break
        end
      end
    else
      flash[:notice] = '<span class="icon warning">Diese Website wurde bereits verifiziert</span>'
    end
    
    respond_to do |format|
      format.html do
        if @website.verified?
          redirect_to edit_user_path(current_user)
        else
          render
        end
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.xml
  def destroy
    @website = Website.find(params[:id])
    @company = @website.company
    redirect_to root_url unless current_user == @company.user
    @website.destroy 

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.js do
        render :update do |page|
          page.remove "website_#{params[:id]}"
          page["websites"].hide if @company.websites.empty?
        end
      end
      format.xml  { head :ok }
    end
  end
end
