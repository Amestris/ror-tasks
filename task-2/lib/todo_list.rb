class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(options=[])
    raise IllegalArgument unless options[:db]
    @db = options[:db]
    @network = options[:network] if options[:network]
  end
  
  def empty?
    @db.items_count == 0
  end
  
  def size 
    @db.items_count
  end
  
  def << (item)
    
      resp  = @db.add_todo_item(item) if item != nil && (!defined?(item.title) || (defined?(item.title) && item.title.length > 3))
      if @network && defined?(item.title)
        item.title = item.title[0..254] if item.title.length>255
        @network.notify 
      end
  end
  
  def first
    @db.get_todo_item(0)# unless @db.items_count == 0
  end

  def last
    @db.get_todo_item(@db.items_count-1)# unless @db.items_count == 0
  end   
  
  def toggle_state(item)
    raise NilObject unless item
    @db.complete_todo_item(item, !item.done)
    if @network && item.done && defined?(item.title)
      item.title = item.title[0..254] if item.title.length>255
      @network.notify 
    end
  end 
end
