class TodoItem < ActiveRecord::Base
  belongs_to :todo_list

  validates :title, presence: true, length: { minimum: 5, maximum: 30}
  validates :todo_list_id, presence: true
  validates :description, length: { maximum: 255 }
  validates :due_date, format: /(0[1-9]|[12][0-9]|3[01])[\/.](0[1-9]|1[012])[\/.](19|20)\d\d/
  
end
