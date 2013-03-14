class TodoList
  class Item
   attr_accessor :txt, :done
   def initialize(text)
     @txt = text
     @done = false
     self.txt = text
     self.done = false
    end
   def to_s
     self.txt
   end
   
   def toggle_state
     self.done = self.done ? false : true
   end
   
   def set_description(new_txt)
     self.txt = new_txt if !new_txt.nil?
   end
   end

  # Initialize the TodoList with +items+ (empty by default).
  def  initialize(items=[])
    raise IllegalArgument.new if items.nil?
    @list=[]
    @list = items.map{|i| Item.new(i) }
  end
  
  def item(index)
    @list[index]
  end
  
  def empty?
    @list.size == 0
  end
  
  def size
    @list.size
  end

  def <<(item_description)
    @list.push Item.new(item_description)
  end
  
  def first
    @list.first
  end
  
  def second
    @list.second
  end
  
  def last
    @list.first
  end

  def complete(nr)
    @list[nr].done = true
  end
  
  def uncomplete(nr)
    @list[nr].done = false
  end
  
  def completed?(nr)
    @list[nr].done
  end 

  def completed_list
    @list.select{|item| item.done == true}
  end
  
  def uncompleted_list
    @list.select{|item| item.done == false}
  end
  
  def remove(nr)
    @list.delete_at(nr)
  end
  
  def remove_completed
    @list.delete_if{|i| i.done}
  end  
  
  def revert_items(i1, i2)
    tmp = @list[i1]
    @list[i1] = @list[i2]
    @list[i2] = tmp    
  end
  
  def revert_all
    @list.reverse!
  end

  def toggle_item_state(nr)
    @list[nr].toggle_state
  end
  
  def sort_items_by_name
    @list.sort!{|a,b| a.txt<=>b.txt}
  end

  def convert_to_text
    newlist = ""
    @list.each do |item|
      newlist << (item.done ? "[X] "+item.txt : "[ ] "+item.txt) << "\n"
    end
    return newlist
  end
end
