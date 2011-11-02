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

    # Creates a new plan and fills it with data from JSON string or parsed hash specified.
    def self.from_json(json)
      hash = json.is_a?(String) ? JSON.parse(json) : json
      plan = PerfectPrice::Plan.new
      
      %w{ name label meta setup_fee monthly_fee }.each do |opt|
        plan.send(opt, hash[opt]) if hash.has_key?(opt)
      end
      
      if hash.has_key?('features')
        hash['features'].each do |feature_name, feature_json|
          plan.features[feature_name.to_sym] = Feature.from_json(feature_json)
        end
      end
      
      plan
    end
    
    # Serializes the plan instance into JSON string.
    def to_json
      hash = {}
      
      %w{ name label meta setup_fee monthly_fee }.each do |opt|
        hash[opt.to_sym] = self.send(opt) if self.send(opt)
      end
      
      if @features
        hash[:features] = @features.inject({}) { |m, item| m[item[0]] = item[1].to_json; m }
      end
      
      hash.to_json
    end
    
  end
end