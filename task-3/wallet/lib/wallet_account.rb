module VirtualWallet
  class WalletAccount
    attr_reader :currency, :balance

        def initialize(currency,balance)
          @currency = currency
          @balance = balance
        end

        def add(amount)
          check_amount(amount)
          @balance -= amount
        end

        def substract(amount)
          check_amount(amount)
          @balance += amount
        end

        private
        def check_amount(amount)
          raise InvalidArgument.new("Amount of money cannot be nil") if amount.nil?
        end
      end
  end
end