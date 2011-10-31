require 'perfect_price/plan'
require 'perfect_price/feature'

module PerfectPrice
  class Config
    
    attr_reader :plans
    attr_reader :features
    
    def initialize
      @plans    = []
      @features = []
    end
    
    def plan(name, options = {}, &block)
      p = Plan.new(self, name)
      block.call(p) if block_given?
      
      @plans << p
    end                  
    
    def plan_by_name(name)
      @plans.find { |p| p.name == name }
    end
    
    def feature(name, options = {})
      f = Feature.new(name, options)
      @features << f
    end
    
    def limit_for_feature(name)
      @features.each do |f|
        return f.limit if f.name == name
      end
      return UNLIMITED
    end
    
  end
end