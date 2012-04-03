class CompaniesController < ApplicationController
  before_filter :require_user

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])
    @company.user = current_user

    respond_to do |format|
      if @company.save
        format.html { redirect_to(edit_user_path(current_user), :notice => '<span class="icon yes">Firma wurde angelegt</span>') }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(:root) }
      format.xml  { head :ok }
    end
  end
end
