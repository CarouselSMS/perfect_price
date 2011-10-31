module PerfectPrice
  class Feature

    attr_reader :name
    attr_reader :base_price
    attr_reader :bundled
    attr_reader :limit
    attr_reader :volume_discounts

    def initialize(name, options = {})
      @name       = name
      @base_price = options[:base_price].to_f
      @bundled    = options[:bundled].to_i
      @limit      = (options[:limit] && options[:limit].to_i) || nil
      @volume_discounts = options.fetch(:volume_discounts, {})
    end
    
    def volume_discount_for(usage)
      @volume_discounts.inject(0) do |m, vd|
        v, d = *vd
        m = d if usage >= v && m < d
        m
      end
    end

  end
end