require_relative 'test_helper'
require_relative '../lib/todo_list'
require_relative '../lib/todo_item'
require_relative '../lib/user'

describe TodoList do
  include TestHelper

   subject(:list) {TodoList.create(title: title, user_id: user_id)}
   let(:title) {"title of item"}
   let(:user_id) {"1"}

     it "should not accept empty title" do
       list.title = ""
       list.should_not be_valid
     end

     it "should not accept empty user" do
       list.user_id = ""
       list.should_not be_valid
     end
     
     it "should find all lists of given user" do
       list
       TodoList.find_by_user(User.find_by_email("ewelina@1000i.pl")).count.should == 2
     end

     it "should find list by id and egearly load its items" do
       l = TodoList.find_with_items(ActiveRecord::Fixtures.identify(:first_list))
       l.title.should == "Pierwsza lista"
       l.todo_items.count.should == 3
     end
    
end
