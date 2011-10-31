require "rubygems"
require "hashie"
require "perfect_price/version"
require "perfect_price/configuration"
require "perfect_price/calculations"

module PerfectPrice
  
  UNLIMITED = nil

  extend PerfectPrice::Configuration
  extend PerfectPrice::Calculations
  
end
