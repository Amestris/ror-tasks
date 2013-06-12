require_relative 'test_helper'
require_relative '../lib/todo_item'

describe TodoItem do
  include TestHelper
  subject(:item) {TodoItem.create(title: title, description: description, todo_list_id: todo_list_id, date_due: date_due)}
  let(:title) {"title of item"}
  let(:description) {"description of item"}
  let(:todo_list_id) {"1"}
  let(:date_due) {"01/06/2013"}
  
    it "should not accept empty title" do
      item.title = ""
      item.should_not be_valid
    end
    
    it "should not accept empty list" do
      item.todo_list_id = ""
      item.should_not be_valid
    end
    
    it "should not accept title > 30" do
      item.title = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
      item.should_not be_valid
    end
    
    it "should not accept title < 5" do
      item.title = "Lore"
      item.should_not be_valid
    end

    it "should not accept description > 255" do
      item.title = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
      item.should_not be_valid
    end

    it "should accept empty description" do
      item.description = ""
      item.should be_valid
    end
    
    it "should accept due date in format dd/mm/yyyy" do
      item.date_due = "1"
      item.should_not be_valid
    end
    
    it "should find items with specific word in description" do
    end

    it "should find items with description exceeding 100 characters" do
    end

    it "should paginate items" do
    end

    it "should find all user items" do
    end

    it "should find all user items with given date due" do
    end

    it "should find items with date due to specific day" do
    end

    it "should find items with date due to specific week" do
    end

    it "should find items with date due to specific month" do
    end

    it "should find overdue items" do
    end
    
    
end
