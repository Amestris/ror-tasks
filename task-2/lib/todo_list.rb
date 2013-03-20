class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    raise IllegalArgument unless items[:db]
    @db = items[:db]
  end
  
  def empty?
    @db.items_count == 0
  end
  
  def size
    @db.items_count
  end
  
  def << (item)
    @db.add_todo_item(item) unless item.title == ""
  end
  
  def first
    @db.get_todo_item(0)
  end

  def last
    
    @db.get_todo_item(@db.items_count-1)
  end  
  
  def toggle_state(item)
    @db.complete_todo_item(item, !@db.todo_item_completed?(item))
  end
end
