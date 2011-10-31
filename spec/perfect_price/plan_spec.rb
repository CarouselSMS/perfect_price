require 'perfect_price'

describe PerfectPrice::Plan do
  
  let(:config) { PerfectPrice::Config.new }
  let(:plan)   { PerfectPrice::Plan.new(config, :plan) }

  it "should accept custom fields" do
    plan.custom(:label => "Label")
    plan.custom[:label].should == "Label"
  end

  it "should accept custom limits" do
    config.feature :projects, :limit => 5
    plan.limit_for_feature(:projects).should == 5
    
    plan.limits(:projects => 3)
    plan.limit_for_feature(:projects).should == 3
    config.limit_for_feature(:projects).should == 5
  end

  it "should return features by name" do
  end
 
end