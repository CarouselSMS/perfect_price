require 'perfect_price'
         
describe PerfectPrice do

  let(:plan) { PerfectPrice.plans.first }
  
  context 'one plan, no fuss' do
    before do
      PerfectPrice.configure do |c|
        c.plan :easy
      end
    end
    
    specify { PerfectPrice.plan_by_name(:easy).should   == plan }
    specify { PerfectPrice.plan_by_name(:hard).should   be_nil }
    specify { PerfectPrice.initial_payment(plan)[:total].should == 0 }
    specify { PerfectPrice.monthly_payment(plan)[:total].should == 0 }
    specify { PerfectPrice.plans.count.should           == 1 }
    specify { plan.name.should        == :easy }
    specify { plan.monthly_fee.should == 0 }
    specify { plan.setup_fee.should   == 0 }
    specify { plan.features.should    be_empty }
  end
  
  context 'two plans' do
    before do
      PerfectPrice.configure do |c|
        c.plan :first
        c.plan :second
      end
    end
    
    specify { PerfectPrice.plans.map(&:name).should == [ :first, :second ] }
  end

  context 'plan w/ fees' do
    before do
      PerfectPrice.configure do |c|
        c.plan :fees do |p|
          p.setup_fee   10
          p.monthly_fee 20
        end
      end
    end
    
    specify { PerfectPrice.initial_payment(plan)[:total].should == 10 }
    specify { PerfectPrice.monthly_payment(plan)[:total].should == 20 }
    specify { plan.setup_fee.should   == 10 }
    specify { plan.monthly_fee.should == 20 }
  end
  
end
