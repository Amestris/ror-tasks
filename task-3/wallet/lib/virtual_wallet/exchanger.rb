module VirtualWallet
  class Exchanger

      def initialize(options=[])
        @source_account = options[:source_account]
        @target_account = options[:target_account]
        @exchanger_base = options[:exchanger_base] if options[:exchanger_base]
      end

      def exchange(limit=nil)
        source_amount = compute_source_amount(limit)
        source_amount = @source_account.balance if !source_amount 
        raise ExchangerBaseConnection unless rate = @exchanger_base.get_rate(@source_account.currency, @target_account.currency) 
        if rate && rate > 0
          target_amount = (source_amount / rate).round(2)
          @source_account.substract(source_amount)
          @target_account.add(target_amount)
        end
      end

      private
      def compute_source_amount(limit)
        if limit.nil? || limit == :all
          @source_account.balance         
        else
          limit
        end
      end

  end
end