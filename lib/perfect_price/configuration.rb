require 'perfect_price/config'

module PerfectPrice
  module Configuration

    attr_accessor :config
  
    def configure(&block)
      block.call @config = PerfectPrice::Config.new
    end                
    
    def plan_by_name(name)
      (config && config.plan_by_name(name)) || nil
    end
    
    def plans
      (config && config.plans) || []
    end
    
    def features
      (config && config.features) || []
    end
  
  end
end