require_relative 'wallet_test_helper'
describe "wallet" do
  include WalletTestHelper

  context "supply arbitrary amount of money in any of the defined currencies" do
    specify "can transfer money from a bank account to wallet with limit" do
      set_bank_account_balance(200)
      set_wallet_balance :eur => 100, :pln => 200
      transfer_money_from_bank_to_wallet(:pln, 100)
      get_wallet_balance(:eur).should == 100
      get_wallet_balance(:pln).should == 100
      get_bank_account_balance().should == 100
    end    
    specify "can transfer money from a bank account to wallet without limit" do
      set_bank_account_balance(200)
      set_wallet_balance :eur => 100, :pln => 200
      transfer_money_from_bank_to_wallet(:pln)
      get_wallet_balance(:eur).should == 100
      get_wallet_balance(:pln).should == 400
      get_bank_account_balance().should == 0
    end
  end
  
  context "demand money to be transfered back to his/her bank account" do
    specify "can demand all money to be transfered back to bank account" do      
      set_bank_account_balance(200)
      set_wallet_balance :eur => 100, :pln => 200
      set_exchange_rate [:eur,:pln] => 4.15
      transfer_money_from_bank_to_wallet(:pln)
      get_wallet_balance(:eur).should == 0
      get_wallet_balance(:pln).should == 0
      get_bank_account_balance().should == 615
    end
  end

  context "convert available money from one currency to another according to a currency exchange table" do
    specify "conversion from EUR to PLN without limit" do
      set_wallet_balance :eur => 100, :pln => 0
      set_exchange_rate [:eur,:pln] => 4.15
      convert_money(:eur,:pln)
      get_wallet_balance(:eur).should == 0
      get_wallet_balance(:pln).should == 415
    end
    specify "conversion from EUR to PLN with limit set to 50" do
      set_wallet_balance :eur => 100, :pln => 0
      set_exchange_rate [:eur,:pln] => 4.15
      convert_money_with_limit(:eur,:pln,50)
      get_wallet_balance(:eur).should == 50
      get_wallet_balance(:pln).should == 207.5
    end
  end
  
  
  context " buying and selling stocks according to stock exchange rates" do    
    specify "buying facebook stock with limit" do
      set_wallet_balance :pln => 150
      set_stock_price(:pln, "facebook", 20)
      buy_stocks(:pln, "facebook", 5)
      get_wallet_balance(:pln).should == 50
      get_wallet_company_stocks("facebook").should == 5 
    end
    specify "selling all facebook stocks" do
      set_wallet_balance :pln => 200
      set_wallet_company_shares :facebook => 5
      set_stock_price(:pln, "facebook", 20)
      sell_stocks("facebook")
      get_wallet_balance(:pln).should == 400
      get_wallet_company_stocks("facebook").should == 0
    end
    specify "selling 3 facebook stocks" do
      set_wallet_balance :pln => 150
      set_wallet_company_stocks :facebook => 5
      set_stock_price(:pln, "facebook", 20)
      sell_stocks("facebook", 3)
      get_wallet_balance(:pln).should == 210
      get_wallet_company_stocks("facebook").should == 2
    end
  end
end
