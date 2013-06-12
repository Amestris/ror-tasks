class TodoItem < ActiveRecord::Base
  attr_accessor :tmp_date
  belongs_to :todo_list
  
  validates :title, presence: true, length: { minimum: 5, maximum: 30}
  validates :todo_list_id, presence: true
  validates :description, length: { maximum: 255 }
  validate :check_date_format
  
  def check_date_format
    errors.add(:date_due, 'date must be in dd/mm/yyyy format') if (tmp_date =~ /[0-3][0-9]\/[0-1][0-9]\/[0-9]{2}(?:[0-9]{2})/)==nil
  end
  
  def self.find_by_word_desc(word)
    where("description LIKE ?", "%#{word}%")
  end
  
  def self.find_with_long_description
    where("LENGTH(description) > 100")
  end

  def self.paginate(page = 0)
      order(:id).offset(page * 2).limit(2)
  end
  
  def self.find_user_items(user)
    where("todo_items.todo_list_id = todo_lists.id AND todo_lists.user_id = ?", user.id).includes(:todo_list)
  end
  
  def self.find_user_items_with_date(user, due_date)
    find_user_items(user).find_by_day(due_date)
  end
  def self.find_by_day(date)
      where("date_due = ?", Time.parse(date))
  end

  def self.find_by_week(week)
    week_start = Time.parse(Date.commercial(Time.now.year, week, 1).to_s)
    week_end = Time.parse(Date.commercial(Time.now.year, week, 7).to_s).end_of_day
    where("date_due BETWEEN ? AND ?", week_start, week_end)
  end

  def self.find_by_month(month)
    where("date_due BETWEEN ? AND ?", Time.new(Time.now.year, month), Time.new(Time.now.year, month).end_of_month)
  end
  
  def self.find_overdue
    where("date_due < ?", Time.now)
  end
  
  def self.find_overdue_with_hour(hour)
    where("date_due = ? OR date_due BETWEEN ? AND ?", Time.now.beginning_of_day, Time.now-hour.hours, Time.now)
  end
end
