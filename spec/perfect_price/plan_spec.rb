require 'perfect_price'

describe PerfectPrice::Plan do
  
  describe 'defaults' do
    its(:setup_fee)   { should == 0 }
    its(:monthly_fee) { should == 0 }
  end
  
end