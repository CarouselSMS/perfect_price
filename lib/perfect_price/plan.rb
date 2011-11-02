module PerfectPrice

  # Plans group features by the name. Each plan definition can have:
  #
  # * <tt>setup_fee</tt> - a fee that's charged once during the initial processing (default 0).
  # * <tt>monthly_fee</tt> - a fee that's charged montly (default 0).
  # * <tt>name</tt> - plan name (usually a symbol) for lookup.
  # * <tt>label</tt> - human-reable name.
  # * <tt>meta</tt> - a hash of any meta-information you want to hold with this plan.
  #   It's useful to hold descriptions and sub-titles for rendering.
  # * <tt>feature</tt> - any number of features you want to go with this plan. Initial set
  #   of features is copied from the global configuration and you have a choice to override
  #   certain parameters (prices, limits) in every individual plan.
  #
  # An example plan definition:
  #
  #     plan :basic, :label => "Basic Features" do
  #
  #       setup_fee   100
  #       monthly_fee 10
  #
  #       meta :subtitle => "Popular choice"
  #
  #       feature :mo
  #       feature :mt do
  #         unit_price 0.01
  #       end
  #     end
  #
  #
  # == Overriding features in plans
  #
  #     PerfectPlan.configure do
  #       feature :mt, :unit_price => 0.05
  #
  #       plan :seniors do
  #         feature :mt, :unit_price => 0.01
  #       end
  #     end
  class Plan

    SNAPSHOT_KEYS = %w{ name label meta setup_fee monthly_fee }

    include Configurable
    option :name
    option :label
    option :meta

    option :setup_fee
    option :monthly_fee
    option :feature, :many => true, :class => Feature

    def initialize
      @setup_fee   = 0
      @monthly_fee = 0
    end

    # Creates a new plan and fills it with data from the snapshot hash specified.
    def self.from_snapshot(hash)
      plan = PerfectPrice::Plan.new
      
      hash.each do |k, v|
        k = k.to_s
        if SNAPSHOT_KEYS.include?(k.to_s)
          plan.send(k, v)
        elsif k == 'features'
          v.each do |feature_name, feature_hash|
            plan.features[feature_name.to_sym] = Feature.from_snapshot(feature_hash)
          end             
        end
      end
      
      plan
    end
    
    # Serializes the plan instance into a hash.
    def to_snapshot
      hash = {}
      
      %w{ name label meta setup_fee monthly_fee }.each do |opt|
        hash[opt.to_sym] = self.send(opt) if self.send(opt)
      end
      
      if @features
        hash[:features] = @features.inject({}) { |m, item| m[item[0]] = item[1].to_json; m }
      end
      
      hash
    end
    
  end
end