require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }

  it { should be_empty }

  it "should raise an exception when nil is passed to the constructor" do
    expect { TodoList.new(nil) }.to raise_error(IllegalArgument)
  end

  it "should have size of 0" do
    list.size.should == 0
  end

  it "should accept an item" do
    list << item_description
    list.should_not be_empty
  end

  it "should add the item to the end" do
    list << item_description
    list.last.to_s.should == item_description
  end

  it "should have the added item uncompleted" do
    list << item_description
    list.completed?(0).should be_false
  end

  context "with one item" do
    let(:items)             { [item_description] }

    it { should_not be_empty }

    it "should have size of 1" do
      list.size.should == 1
    end

    it "should have the first and the last item the same" do
      list.first.to_s.should == list.last.to_s
    end

    it "should not have the first item completed" do
      list.completed?(0).should be_false
    end

    it "should change the state of a completed item" do
      list.complete(0)
      list.completed?(0).should be_true
    end
  end

  context "with list of items" do
    let(:item1)    { "Buy toilet" }
    let(:item2)    { "Buy paper" }
    let(:item3)    { "Buy chicken" }
    let(:items) { [item1, item2, item3] }
    
    it "should return completed items" do
      list.complete(1)
      list.complete(2)

      list.completed_list.size.should == 2
      list.completed_list.first.txt.should == item2
      list.completed_list[1].txt.should == item3
    end

    it "should return uncompletetd items" do
      list.complete(0)
      list.complete(2)
      list.uncompleted_list.size.should == 1
      list.uncompleted_list.first.txt.should == item2
    end

    it "should remove individual item" do
      list.remove(0)
      list.size.should == items.size-1
      list.item(0).txt.should == item2
      list.item(1).txt.should == item3
    end
    
    it "should remove all completed items" do
      list.complete(0)
      list.complete(2)
      list.remove_completed
      list.size.should == items.size-2
      list.item(0).txt.should == item2
    end
    it "should revert order of two items" do
      list.revert_items(0,2)
      list.size.should == items.size
      list.item(0).txt.should == item3
      list.item(1).txt.should == item2
      list.item(2).txt.should == item1
    end
    
    it "should revert order of all items" do
      list.revert_all
      list.size.should == items.size
      list.item(0).txt.should == item3
      list.item(1).txt.should == item2
      list.item(2).txt.should == item1
    end
    
    it "should toggle the state of an item" do
      list.item(1).toggle_state
      list.item(1).done.should == true
      list.item(1).toggle_state
      list.item(1).done.should == false
      
      list.complete(0)
      list.item(0).done.should == true
      list.item(0).toggle_state
      list.item(0).done.should == false
      
      list.toggle_item_state(0)
      list.item(0).done.should == true
    end
    it "should set the state of the item to uncompleted" do
      list.complete(0)
      list.item(0).done.should == true
      list.uncomplete(0)
      list.item(0).done.should == false
    end
    it "should change the description of an item" do
      list.item(2).set_description("do a homework")      
      list.item(0).txt.should == "Buy toilet"
      list.item(1).txt.should == "Buy paper"
      list.item(2).txt.should == "do a homework"      
    end
    it "should sort the items by name" do
      list.item(0).set_description("save the date")
      list.item(1).set_description("add date to calendar")
      list.item(2).set_description("find a present for young_couple")      
      list.sort_items_by_name
      list.item(0).txt.should == "add date to calendar"
      list.item(1).txt.should == "find a present for young_couple"
      list.item(2).txt.should == "save the date"
    end
    it "should convert list to text" do
      list.complete(1)
      new_list = list.convert_to_text
      new_list.gsub!(/\n/, " ").strip.should == "[ ] Buy toilet [X] Buy paper [ ] Buy chicken"
    end
  end
end
