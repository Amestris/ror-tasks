require_relative '../../lib/virtual_wallet/exchanger'
require_relative '../../lib/virtual_wallet/wallet_account'
require_relative '../../lib/virtual_wallet/exceptions'
require_relative 'spec_helper'

module VirtualWallet
  describe Exchanger do
    subject(:exchanger)   { Exchanger.new(source_account: account_pln,target_account: account_eur, exchanger_base: exchanger_base) }
    let(:account_eur)     { WalletAccount.new(:eur, 100) }
    let(:account_pln)     { WalletAccount.new(:pln, 100)}
    let(:rate)            { 0 }
    let(:exchanger_base)  { mock }
    
    it "should accept transfering money between different currency" do
      mock(exchanger_base).get_rate(:pln,:eur) { 4.15 }
      exchanger.exchange(50)
      account_eur.balance.should == 112.05
      account_pln.balance.should == 50
    end
    
    it "should transfer all money from 1 currency to another" do
      mock(exchanger_base).get_rate(:pln,:eur) { 4.15 }
      exchanger.exchange()
      account_eur.balance.should == 124.10
      account_pln.balance.should == 0
    end
    
    it "should return getting exchanger rate error" do
      mock(exchanger_base).get_rate(:pln,:eur) { nil }
      expect{ exchanger.exchange(50) }.to raise_error(ExchangerBaseConnection)
      
    end
  end
end
