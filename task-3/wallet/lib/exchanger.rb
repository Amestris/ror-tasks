module VirtualWallet
  class Exchanger

      def initialize(source_account,target_account,rate)
        @source_account = source_account
        @target_account = target_account
        @rate = rate
      end

      def exchange(limit=nil)
        source_amount = compute_source_amount(limit)
        source_amount = @source_account.balance if !source_amount 
        target_amount = source_amount * @rate
        @source_account.add(source_amount)
        @target_account.substract(target_amount)
      end

      private
      def compute_source_amount(limit)
        return @source_account.balance if limit.nil? || limit == :all        
      end

  end
end