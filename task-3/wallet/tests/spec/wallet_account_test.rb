require_relative '../../lib/virtual_wallet/wallet_account'
require_relative '../../lib/virtual_wallet/exceptions'
require_relative 'spec_helper'

module VirtualWallet
  describe WalletAccount do
    subject(:account)     { WalletAccount.new(currency,balance) }
    subject(:account_pl)  { WalletAccount.new(currency_pl,balance_pl) }
    let(:currency)        { :eur }
    let(:currency_pl)     { :pl }
    let(:balance)         { 100 }
    let(:balance_pl)      { 150 }

    it "should return its currency" do
      account.currency.should == currency
    end

    it "should return its balance" do
      account.balance.should == balance
    end

    it "should accept adding money" do
      account.add(50)
      account.balance.should == 150
    end

    it "should accept substracting money" do
      account.substract(50)
      account.balance.should == 50
    end

    it "should accept negative deposits" do
      account.add(-50)
      account.balance.should == 50
    end

    it "should accept negative withdrawals" do
      account.substract(-50)
      account.balance.should == 150
    end

    it "should not accept invalid withdrawals" do
      expect { account.substract(nil)}.to raise_error(InvalidArgument)
    end

    it "should not accept invalid deposits" do
      expect { account.add(nil)}.to raise_error(InvalidArgument)
    end
    
  end
end