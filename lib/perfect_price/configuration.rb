module PerfectPrice
  class Configuration

    include Configurable
    option :feature, :many => true, :class => Feature
    option :plan,    :many => true, :class => Plan, :copy => :features
  
  end
end