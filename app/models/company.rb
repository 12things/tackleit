class Company < ActiveRecord::Base
  has_many :websites, :dependent => :destroy
  has_many :employments, :dependent => :destroy
  has_many :employees, :through => :employments, :source => :user
  belongs_to :user
  
  validates_presence_of :name
  
end
