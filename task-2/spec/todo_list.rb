require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(db: database) }
  let(:database)            { stub }
  let(:nilitem)             { nil }
  let(:item)                { Struct.new(:title,:description, :done).new(title, description, false) }  
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it "should raise an excepti on if the database layer is not provided" do
    expect{ TodoList.new(db: nil) }.to raise_error(IllegalArgument)
  end

  it "should be empty if there are no items in the DB" do
    stub(database).items_count { 0 }
    list.should be_empty
  end

  it "should not be empty if there are some items in the DB" do
    stub(database).items_count { 1 }
    list.should_not be_empty
  end

  it "should return its size" do
    stub(database).items_count { 6 }

    list.size.should == 6
  end

  it "should persist the added item" do
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }
    stub(database).items_count { 1 }

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    stub(database).get_todo_item(0) { item }
    mock(database).complete_todo_item(item,true) {item.done = true; true }
    mock(database).complete_todo_item(item,false) {item.done = false; true }

    list.toggle_state(item)
    item.done.should == true
    list.toggle_state(item)
    item.done.should == false
  end

  it "should fetch the first item from the DB" do
    mock(database).get_todo_item(0) { item }
    stub(database).items_count { 6 }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end

  it "should fetch the last item from the DB" do
    stub(database).items_count { 6 }

    mock(database).get_todo_item(5) { item }
    list.last.should == item

    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end

  it "should return nil for the first and the last item if the DB is empty" do
    stub(database).items_count { 0 }
    mock(database).get_todo_item(0) { nil }
    mock(database).get_todo_item(-1) { nil }

    list.should be_empty
    list.first.should == nil
    list.last.should == nil    
  end

  it "should raise an exception when changing the item state if the item is nil" do
    stub(database).get_todo_item(0) { nilitem }
    expect{ list.toggle_state(nilitem) }.to raise_error(NilObject)
  end
  it "should not accept a nil item" do
    dont_allow(database).add_todo_item(nilitem)
    list << nilitem    
  end
  
  context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)
      list << item
    end
  end
  
  context "with short title of the item" do 
    let(:title)   { "cut" }
    
    it "should not accept an item with too short (but not empty) title" do
      dont_allow(database).add_todo_item(item)
      list << item
    end
  end
  
  context "with missing description" do
    let(:item_nodescription) { Struct.new(:title,:done).new(title, false) }
    
    it "should accept of an item with missing description" do
      mock(database).add_todo_item(item_nodescription) { true }
      list << item_nodescription
    end
  end
  
  context "with social network" do
    subject(:list) { TodoList.new(db: database, network: social_network) }
    let(:social_network) { stub }    
    let(:item_notitle) { Struct.new(:description,:done).new(description, false) }
    let(:item_nobody) { Struct.new(:title,:done).new(title, false) }
    
    it "notifying a social network if an item is added to the list (you have to provide the social network proxy in the constructor)" do 
      mock(database).add_todo_item(item) { true }
      mock(social_network).notify { true }
      list << item
    end
    
    it "should notify a social network if an item is completed" do
      stub(database).get_todo_item(0) { item }
      mock(database).complete_todo_item(item,true) { item.done = true; true }
      mock(social_network).notify { true }
      
      list.toggle_state(item)
      item.done.should == true
    end
    
    it "should not notify the social network if the title of the item is missing" do
      mock(database).add_todo_item(item_notitle) { true }
      mock(database).add_todo_item(item) { true }
      mock(database).complete_todo_item(item_notitle,true) { item_notitle.done = true; true }
      mock(database).complete_todo_item(item,true) { item.done = true; true }
      mock(social_network).notify.times(2) { true }
      
      list << item_notitle
      list << item
      list.toggle_state(item_notitle)
      item_notitle.done.should == true
      list.toggle_state(item)
      item.done.should == true
    end
    
    it "should notify the social network if the body of the item is missing" do
      mock(database).add_todo_item(item_nobody) { true }
      mock(database).complete_todo_item(item_nobody,true) { item_nobody.done = true; true }
      mock(social_network).notify.times(2) { true }
      
      list << item_nobody
      list.toggle_state(item_nobody)
    end
  end

  context "context with long title" do
    subject(:list) { TodoList.new(db: database, network: social_network) }
    let(:social_network) { stub }
    let(:title) {"t"*256}
    it "should cut the title of the item when notifying the SN if it is longer than 255 chars - adding item" do
      mock(database).add_todo_item(item) { true }
      mock(social_network).notify { true }
      
      item.title.size.should == 256
      list << item
      item.title.size.should == 255
    end
    
    it "should cut the title of the item when notifying the SN if it is longer than 255 chars - complete item" do
      stub(database).get_todo_item(0) { item }
      mock(database).complete_todo_item(item,true) { item.done = true; true  }
      mock(social_network).notify { true }
      
      item.title.size.should == 256
      list.toggle_state(item)
      item.title.size.should == 255
    end
  end
  
end
