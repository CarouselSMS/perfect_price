module PerfectPrice

  # Features define three aspects of plans and can combine any of the following:
  #
  # * Purely cosmetic definition of a feature for the feature table rendering
  #
  #       feature :projects, :label => "Projects"
  #
  # * Limits of usage
  #
  #       feature :projects, :limit => 35
  #
  # * Pricing details
  #
  #       feature :messages do
  #         unit_price        0.05
  #         bundled           100
  #         volume_discounts  500 => 0.01, 2000 => 0.02
  #       end
  #
  # Both types of definitions (through the inline hash and block) are equivalent.

  class Feature # :nodoc:

    include Configurable
    option :name
    option :limit
    option :unit_price
    option :bundled
    option :volume_discounts
    
    # Returns the discount for the given usage as defined by the <tt>volume_discounts</tt>
    # option.
    def volume_discount_for(usage)
      return 0 unless @volume_discounts
      @volume_discounts.inject(0) do |m, vd|
        v, d = *vd
        m = d if usage >= v.to_i && m < d
        m
      end
    end

    # Creates a new feature and fills it with data from JSON string or parsed hash specified.
    # Only recognized fields are set and some are converted to proper types:
    #
    # * <tt>name</tt> is converted to Symbol.
    # * <tt>volume_discounts</tt> is converted into the hash of integers mapped to the value as-is.
    #
    # Returns the <tt>Feature</tt> instance.
    def self.from_json(json)
      hash = json.is_a?(String) ? JSON.parse(json) : json
      feature = self.new
      
      %w{ limit unit_price bundled }.each do |opt|
        feature.send(opt, hash[opt]) if hash.has_key?(opt)
      end
      
      feature.name(hash['name'].to_sym) if hash.has_key?('name')
      
      if hash.has_key?('volume_discounts')
        vd = hash['volume_discounts'].inject({}) do |m, vi|
          k, v = *vi
          m[k.to_i] = v
          m
        end

        feature.volume_discounts vd
      end
      
      feature
    end
    
    # Serializes the feature instance into JSON string.
    def to_json
      hash = {}
      
      %w{ name limit unit_price bundled volume_discounts }.each do |opt|
        hash[opt.to_sym] = self.send(opt) if self.send(opt)
      end
      
      hash.to_json
    end
    
  end
end