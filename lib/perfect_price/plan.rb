module PerfectPrice
  class Plan
                    
    attr_reader :name

    def initialize(config, name)
      @config      = config
      @limits      = {}
      
      @name        = name
      @setup_fee   = 0
      @monthly_fee = 0
    end
    
    def setup_fee(*args)
      @setup_fee = [ 0, args.first ].max if args.first
      @setup_fee
    end
    
    def monthly_fee(*args)
      @monthly_fee = [ 0, args.first ].max if args.first
      @monthly_fee
    end
    
    def custom(*args)
      @custom = args.first if args.first
      @custom
    end
    
    def features
      @config.features
    end
    
    def limits(hash)
      @limits.merge!(hash)
    end
      
    def limit_for_feature(feature_name)
      @limits.fetch(feature_name, @config.limit_for_feature(feature_name))
    end
    
    def feature_by_name(feature_name)
      @config.features.find { |f| f.name == feature_name }
    end
  end
end