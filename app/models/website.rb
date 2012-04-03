class Website < ActiveRecord::Base
  has_many :messages, :dependent => :destroy
  belongs_to :company
  
  validates_presence_of :host
  validates_uniqueness_of :host, :message => "existiert bereits"
  
  scope :claimed, where("verified = ?", true)
  
  def microid user, with_prefix=false
    digest = Digest::SHA1.hexdigest(
      Digest::SHA1.hexdigest('mailto:'+user.email) +
      Digest::SHA1.hexdigest(url)
    )
    return (with_prefix ? 'mailto+http:sha1:' : '') + digest
  end
  
  def microid_tag user
    '<meta content="'+microid(user, true)+'" name="microid">'
  end
  
  def url
    return "http://" + self.host.to_s + "/"
  end
  
  def full_title
    self.title.blank? ? self.host : self.title
  end
end
