module PerfectPrice
  module Calculations
    
    # Calculating the initial payment for the account given the plan.
    #
    # Returns the hash with the following keys:
    #
    # * <tt>:total</tt> - total payable.
    # * <tt>:details</tt> - detailed breakdown of the total in the form of a hash.
    #
    def initial_payment(plan)
      Hashie::Mash.new(
        :total   => plan.setup_fee,
        :details => {
          :setup_fee => plan.setup_fee
        })
    end
    
    # Calculating the monthly payment for the account given the plan
    # and options.
    #
    # Available options:
    #
    # * <tt>:credits</tt> - the hash mapping feature names to the number of credits left.
    #
    # * <tt>:usage</tt> - the hash mapping feature names to the number of items used
    #   during this period.
    #
    # Returns the hash:
    #
    # * <tt>:total</tt> - total payable.
    # * <tt>:details</tt> - detailed breakdown of the total by features and fees.
    # * <tt>:credits</tt> - updated credits hash.
    #
    def monthly_payment(plan, options = {})
      total = plan.monthly_fee
      details = { :monthly_fee => total }
      
      credits = options.fetch(:credits, {})
      options.fetch(:usage, {}).each do |feature_name, usage|
        next if usage == 0
        total += include_feature_usage(plan, details, feature_name, usage, credits)
      end
      
      Hashie::Mash.new(
        :total   => total,
        :details => details,
        :credits => credits)
    end

    private
    
    def include_feature_usage(plan, details, feature_name, usage, credits)
      feature = plan.feature(feature_name)
      return 0 if !feature

      # Get discount for original usage
      discount = feature.volume_discount_for(usage)
      details["#{feature_name}_volume_discount"] = discount if discount > 0

      # Remove bundled
      bundled_used = [ usage, feature.bundled || 0 ].min
      details["#{feature_name}_bundled_used"] = bundled_used
      usage -= bundled_used
      return 0 if usage == 0

      # Use some credits if any present
      credits_used = [ usage, credits.fetch(feature_name, 0) ].min
      if credits_used > 0
        details["#{feature_name}_credits_used"] = credits_used
        usage -= credits_used
        credits[feature_name] -= credits_used
        return 0 if usage == 0
      end
      
      # Calculate the cost of the rest
      unit_price = feature.unit_price || self.config.feature(feature_name).unit_price
      feature_total = usage * (feature.unit_price - discount)
      details["#{feature_name}_fee"] = feature_total

      return feature_total
    end
  end
end