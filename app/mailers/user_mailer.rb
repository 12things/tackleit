class UserMailer < ActionMailer::Base
  layout 'email' # use email.(html|text).erb as the layout
  default :from => "tackle it! <noreply@tackleit.de>"
  
  def account_activation(user)
    @user = user
    @url  = activation_url(@user.perishable_token)
    mail(:to => user.email,
         :subject => "[tackleit] Aktiviere deinen Account, #{user.email}!")
  end
  
  def message_notification(message)
    @message = message
    @website = message.website
    to_mail = message.website.email||message.website.company.user.email
    mail(:to => to_mail,
         :subject => "[tackleit] #{message.msg_type}: #{message.teaser.gsub(/\n/, ' ')}!")
  end

  def comment_notification(comment)
    @comment = comment
    @message = @comment.message
    @website = @comment.message.website
    to_mail = @message.user.email
    mail(:to => to_mail,
         :subject => "[tackleit] #{comment.teaser.gsub(/\n/, ' ')}!")
  end
  
  
end
