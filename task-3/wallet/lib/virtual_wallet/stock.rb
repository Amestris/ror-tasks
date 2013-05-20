module VirtualWallet
class Stock
  attr_reader :company, :ammount

  def initialize(currency,company, price)
    @company = company
    @currency = currency
    @price = price
  end
              
end
end
