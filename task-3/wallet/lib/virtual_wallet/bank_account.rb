module VirtualWallet
  class BankAccount
    
    def initialize()
      @balance = 0
    end
    
    def add(money)
      @balance += money
    end
    
    def substract(money)
      @balance -= money
    end
    
  end
end
