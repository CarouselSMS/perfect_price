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

  class Feature :nodoc:

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
        m = d if usage >= v && m < d
        m
      end
    end

  end
end