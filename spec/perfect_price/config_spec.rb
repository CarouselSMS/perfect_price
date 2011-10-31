require 'perfect_price'

describe PerfectPrice::Config do
  
  let(:config) { PerfectPrice::Config.new }
                      
  describe '#plan' do
    before  { config.plan :sample }
    specify { config.plan_by_name(:sample).should be }
    specify { config.plan_by_name(:unknown).should_not be }
  end
  
  describe 'feature definitions' do
    before do
      config.feature :projects, :label => 'Projects', :limit => 35
      config.plan :sample
      
      @plan = config.plans.first
    end
    
    specify { @plan.features.map(&:name).should == [ :projects ] }
  end 
    
  describe 'limits' do
    before  { config.feature :feature, :limit => 5 }
    specify { config.limit_for_feature(:unknown_feature).should be_nil }
    specify { config.limit_for_feature(:feature).should == 5 }
  end
  
end