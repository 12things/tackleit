class CommentsController < ApplicationController
  before_filter :require_user
  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    
    message = Message.find(params[:message_id]);
    user = current_user
    
    if user.active? && !current_user
      @message.errors.add_to_base("Du musst erst den Link in der E-Mail klicken.")

      respond_to do |format|
        format.html { render :action => "new"; return }
        format.widget { render :action => "new"; return }
      end
    end
    
    @comment.user = user
    @comment.message = message
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(message, :notice => '<span class="icon yes">Kommentar hinzugefügt</span>') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @message = @comment.message
    @comment.destroy if current_user == @comment.user

    respond_to do |format|
      format.html { redirect_to(@message) }
      format.js do
        render :update do |page|
          page.remove "comment_#{params[:id]}"
        end
      end
      format.xml  { head :ok }
    end
  end
end
