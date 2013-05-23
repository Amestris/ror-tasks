class User < ActiveRecord::Base
  has_many :todo_lists
  has_many :todo_items, :through => :todo_lists
  
  attr_accessor :terms_of_service
  
  validates :name, presence: true, length: { maximum: 20}
  validates :surname, presence: true, length: { maximum: 30}
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password, presence: true, confirmation: true, length: { minimum: 10}
  validates :terms_of_service, :acceptance => true
  validates :failed_login_count, presence: true

end
