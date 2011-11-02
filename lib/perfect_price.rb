require "rubygems"
require "hashie"
require "perfect_price/version"
require 'perfect_price/configurable'
require 'perfect_price/feature'
require 'perfect_price/plan'
require "perfect_price/configuration"
require "perfect_price/calculations"

module PerfectPrice
  
  UNLIMITED = nil

  extend PerfectPrice::Calculations

  def self.configure(&block)
    @config = Configuration.new
    @config.instance_eval(&block)
    @config
  end
  
  def self.plan(name)
    name = name.to_sym
    @config && @config.has_plan?(name) && @config.plan(name) || nil
  end
  
  def self.plans
    (@config || Configuration.new).plans
  end
  
end
