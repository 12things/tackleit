class EmploymentsController < ApplicationController
  before_filter :require_user
  
  def create_multiple
    @company = Company.find(params[:company_id])
    redirect_to root_url unless current_user == @company.user
    emails = params[:emails].split(',')
    employments = []
    
    emails.each do |email|
      user = User.where("email = ?", email.strip).first
      unless user.nil? || !user.active? || @company.employees.include?(user)
        employments << Employment.create({:company => @company, :user => user})
        #UserMailer.topic_invitation(user, @topic).deliver
      end
    end
    
    respond_to do |format|
      format.html do 
        redirect_to(edit_user_path(current_user), 
          :notice => '<span class="icon '+ (employments.size>0 ? 'yes' : 'warning') +'">' + 
                      employments.size.to_s + 
                      ' von ' + emails.size.to_s + ' ' + 
                      (emails.size==1 ? "Mitarbeiter wurde" : "Mitarbeitern wurden") + ' hinzugefügt.')
      end
    end
  end
  
  def destroy
    @employment = Employment.find(params[:id])
    @company = @employment.company
    redirect_to root_url unless current_user == @company.user
    was_mine = @employment.user == current_user
    @employment.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.js do
        render :update do |page|
          page.remove "employment_#{params[:id]}"
          page.remove "my_employment_#{params[:id]}" if was_mine
          page["employers"].hide if was_mine && current_user.employments.empty?
          page["employees"].hide if @company.employments.empty?
        end
      end
      format.xml  { head :ok }
    end
  end
end
