require 'perfect_price'
         
describe PerfectPrice do

  let(:plan) { PerfectPrice.plan(:base) }
  
  context 'one plan, no fuss' do
    before do
      PerfectPrice.configure do
        plan :base
      end
    end
    
    specify { PerfectPrice.plan(:hard).should be_nil }
    specify { PerfectPrice.initial_payment(plan)[:total].should == 0 }
    specify { PerfectPrice.monthly_payment(plan)[:total].should == 0 }
    specify { PerfectPrice.plans.count.should           == 1 }
    specify { plan.name.should        == :base }
    specify { plan.monthly_fee.should == 0 }
    specify { plan.setup_fee.should   == 0 }
    specify { plan.features.should    be_empty }
  end
  
  context 'two plans' do
    before do
      PerfectPrice.configure do
        plan :first
        plan :second
      end
    end
    
    specify { PerfectPrice.plans.keys.should =~ [ :first, :second ] }
  end

  context 'plan w/ fees' do
    before do
      PerfectPrice.configure do
        plan :base do
          setup_fee   10
          monthly_fee 20
        end
      end
    end
    
    specify { PerfectPrice.initial_payment(plan)[:total].should == 10 }
    specify { PerfectPrice.monthly_payment(plan)[:total].should == 20 }
    specify { plan.setup_fee.should   == 10 }
    specify { plan.monthly_fee.should == 20 }
  end
  
end
