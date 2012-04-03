class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.disable_perishable_token_maintenance(true)
  end

  has_one :company
  has_many :messages

  has_many :employments, :dependent => :destroy
  has_many :employers, :through => :employments, :source => :company

  before_validation :generate_password
  before_create :generate_perishable_token
  after_create :send_account_activation
  
  
  def send_account_activation
    UserMailer.account_activation(self).deliver    
  end
  
  def generate_perishable_token
    self.reset_perishable_token
  end
  
  def generate_password
    if self.new_record? && self.password.blank?
      size=6
      chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
      self.password = self.password_confirmation = (1..size).collect{|a| chars[rand(chars.size)] }.join
    end
  end
  
  def activate!
    self.active = true
    save
  end
  
  def full_name
    self.name.blank? ? self.email : self.name
  end
end