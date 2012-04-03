class Comment < ActiveRecord::Base
  belongs_to :message, :counter_cache => true
  belongs_to :user
  
  validates_presence_of :text, :comment => "muss ausgefüllt werden"
  
  scope :newest, order("updated_at DESC")
  scope :chronological, order("updated_at ASC")

  after_create :send_notification  
  
  def send_notification
    UserMailer.comment_notification(self).deliver    
  end
  
  def employee? user
    message.website.company.employees.include? user if message.website.company
  end

  def teaser
    self.text.truncate(50)
  end
end
