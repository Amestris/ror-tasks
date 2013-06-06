class TodoList < ActiveRecord::Base
  belongs_to :user
  has_many :todo_items
  
  validates :title, presence: true
  validates :user_id, presence: true
  
  def self.find_by_user(user)
    where(user_id: user.id)
  end

  def self.find_with_items(id)
    where(id: id).includes(:todo_items).first
  end
end
