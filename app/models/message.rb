class Message < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  belongs_to :website, :counter_cache => true
  belongs_to :user
  
  attr_accessor :website_email, :email, :url

  validates_presence_of :text, :message => "muss ausgefüllt werden"
  validates_presence_of :url, :message => "muss ausgefüllt werden"
  
  scope :newest, order("updated_at DESC")
  
  after_create :send_notification  
  
  def send_notification
    UserMailer.message_notification(self).deliver    
  end
  
  def get_url
    return self.website ? (self.website.url + self.path) : self.path
  end
  
  def teaser
    self.text.truncate(50)
  end
  
  def employee? user
    website.company.employees.include? user if website.company
  end
end
