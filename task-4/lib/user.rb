require 'bcrypt'
class User < ActiveRecord::Base
  include BCrypt
  has_many :todo_lists
  has_many :todo_items, :through => :todo_lists
  
  attr_accessor :terms_of_use
  
  validates :name, presence: true, length: { maximum: 20}
  validates :surname, presence: true, length: { maximum: 30}
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :if => Proc.new{|f| !f.email.blank? }
  validates :password, presence: true, confirmation: true, length: { minimum: 10}
  validates :terms_of_use, :acceptance => true
  validates :failed_login_count, presence: true
  
  def self.find_by_surname(val)
    where("surname = ?", val).first
  end
  
  def self.find_by_email(val)
    where("email = ?", val).first
  end

  def self.find_suspicious_users
      where("failed_login_count > 2")
  end
    
  def self.authenticate(email, password)
      if (user = find_by_email(email))
        if user.password == password
          return true
        else
        user.update_attribute(:failed_login_count, user.failed_login_count += 1)
        end
      end
      return false
  end
  
  def password=(new_password)
      super(Password.create(new_password))
    end

    def password
      Password.new(super)
    end
end
