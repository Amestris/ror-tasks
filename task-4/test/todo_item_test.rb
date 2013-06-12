require_relative 'test_helper'
require_relative '../lib/todo_item'
require_relative '../lib/todo_list'
require_relative '../lib/user'


describe TodoItem do
  include TestHelper
  subject(:item) {TodoItem.create(title: title, description: description, todo_list_id: todo_list_id, date_due: date_due, tmp_date: date_due)}
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
    context "with other date format" do
      let(:date_due) {"1"}

      it "should accept due date in format dd/mm/yyyy" do
        item.should_not be_valid
      end
    end
    
    it "should find items with specific word in description" do
      item
      TodoItem.find_by_word_desc("dziadek").count.should == 1
    end

    it "should find items with description exceeding 100 characters" do
      item
      TodoItem.find_with_long_description.count.should == 1
    end

    it "should paginate items" do
      item
      TodoItem.paginate.collect{|i| i.id}.should == [1,2]
      TodoItem.paginate(1).collect{|i| i.id}.should == [3,4]
    end

    it "should find all user items" do
      item
      TodoItem.find_user_items(User.find(1)).count.should == 4
    end

    it "should find all user items with given date due" do
      item
      TodoItem.find_user_items_with_date(User.find(1), "3.6.2013").count.should == 1
    end

    it "should find items with date due to specific day" do
      item
      TodoItem.find_by_day("3.6.2013").count.should == 1
    end

    it "should find items with date due to specific week" do
      item
      TodoItem.find_by_week(23).count.should == 3
    end

    it "should find items with date due to specific month" do
      TodoItem.find_by_month(6).count.should == 6
    end

    it "should find overdue items" do
      TodoItem.find_overdue.count.should == 6
    end
    
    it "should find items that are due in the next n hours" do
      TodoItem.find_overdue_with_hour(3).count.should == 1
    end
    
end
