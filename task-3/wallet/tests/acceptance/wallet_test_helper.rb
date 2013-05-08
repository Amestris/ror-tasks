$:.unshift(File.join(File.dirname(__FILE__),"lib"))
require "virtual_wallet"
include VirtualWallet

module WalletTestHelper
  
  #bank account operations
  def set_bank_account_money(money)
    @bank_account ||= BankAccount.new()
    @bank_account.add(money)
  end
  
  def get_bank_account_balance
    return @bank_account.balance
  end
  
#  def substract_money_from_bank_account(money)
#  	@bank_account.substract(money)
#  end

  #wallet operations
  def set_wallet_balance(wallet_accounts)
    @wallet_accounts ||= []
    wallet_accounts.each do |currency,balance|
      @wallet_accounts << WalletAccount.new(currency, balance)
    end
  end

  def get_wallet_balance(currency)
    return @wallet_accounts.find(:currency => currency).balance
  end
  
  def find_wallet_account(currency)
      @accounts.find{|a| a.currency == currency }
  end

  def find_rate(from_currency,to_currency)
      @rates.find{|r| r.from_currency == from_currency && r.to_currency == to_currency}
  end
  
#  def add_wallet_money(currency, money)
#	  wallet = @wallet_accounts.find(:currency => currency)
#	  wallet.balance += money
#  end 

  #def substract_money_from_wallet(currency, money)
  #  wallet_account = @wallet_accounts.find(:currency => currency)
  #  wallet_account.balance -= money
  #end
  
  def transfer_money_from_wallet_to_bank(currency, ammount=nil)
    ammount ||= get_wallet_balance(currency)
    @bank_account.add(ammount)
    find_wallet_account(currency).substract(ammount)
  end

  def transfer_money_from_bank_to_wallet(currency, ammount=nil)
    ammount ||= get_bank_account_balance()
	  find_wallet_account(currency).add(ammount)
	  @bank_account.substract(ammount)
  end
  
  def find_exchange_rate(from_currency, to_currency)
    ex_rate = @rates.find{|a| a.source_currency == from_currency && a.target_currency == to_currency }
    return ex_rate.rate
  end
  
  def set_exchange_rate(rates)
    @rates ||= []
    rates.each do |(from_currency,to_currency),rate|
      @rates << ExchangeRate.new(from_currency,to_currency,rate)
    end
  end
  #convert between wallet accounts
  def convert_money(from_currency,to_currency)
    exchanger = Exchanger.new(find_wallet_account(from_currency),find_wallet_account(to_currency), find_exchange_rate(from_currency, to_currency))
    exchanger.exchange(:all)
  end

  def convert_money_with_limit(from_currency,to_currency,limit)
    exchanger = Exchanger.new(find_wallet_account(from_currency),find_wallet_account(to_currency), find_exchange_rate(from_currency, to_currency))
    exchanger.exchange(limit)
  end
    
  #stocks operations
  def set_stock_price(currency, company, price)
  	@stocks ||= []
	  stock = @stocks.find(:company => company)
	  
	  if stock
		  stock.price = price
	  else
		  @stocks << Stock.new(currency, company, price)
	  end
  end
  
  def find_wallet_company(company)
    @wallet_stocks.find{|a| a.company == company }
  end
    
  def buy_stocks(currency, company, ammount)
	  stock = @stocks.find(:company => company)
	  find_wallet_account(currency).substract(ammount* stock.price)
	  find_wallet_company(company).buy(ammount)
  end
  
  def sell_stocks(company, ammount=nil)
    stock = @stocks.find(:company => company)
    
    wallet_account = find_wallet_account(stock.currency)
    if wallet_account
      wallet_account.add(ammount*stock.price)
      find_wallet_company(company).sell(ammount)
    end
  end
  
  def set_wallet_company_stocks(stocks)
    @wallet_stocks ||= []
    stocks.each do |company, ammount|
      @wallet_stocks << WalletStock.new(company, ammount)
    end
  end


end
