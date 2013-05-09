module VirtualWallet
  class WalletStock
    attr_reader :company, :ammount

    def initialize(company,ammount)
      @company = company
      @ammount = ammount
    end
    
    def buy(ammount)
      @ammount +=ammount
    end
    
    def sell(ammount=nil)
      ammount = @ammount if ammount.nil?
      @ammount -= ammount
    end
  end
end