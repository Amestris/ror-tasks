class TodoItem < ActiveRecord::Base
  belongs_to :todo_list

  validates :title, presence: true, length: { minimum: 5, maximum: 30}
  validates :todo_list_id, presence: true
  validates :description, length: { maximum: 255 }
  validate :date_due_format
  
  protected
  def date_due_format
    errors.add(:date_due, 'date must be in dd/mm/yyyy format') if @date && ((DateTime.strptime(@date, "%d/%m/%Y") rescue ArgumentError) == ArgumentError)
  end
  
end
