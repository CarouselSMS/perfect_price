require 'perfect_price'

describe PerfectPrice::Plan do
  
  describe 'defaults' do
    its(:setup_fee)   { should == 0 }
    its(:monthly_fee) { should == 0 }
  end
  
  describe 'to_snapshot' do
    let(:plan) { PerfectPrice::Plan.new }

    specify { plan.to_snapshot.should == { :setup_fee => 0, :monthly_fee => 0 } }
    
    it 'should dump basic options' do
      plan.instance_eval do
        name        "name_val"
        label       "label_val"
        meta        :a => 1, :b => 2
        setup_fee   10
        monthly_fee 20
      end
      
      plan.to_snapshot.should == {
        :name        => 'name_val',
        :label       => 'label_val',
        :meta        => { :a => 1, :b => 2 },
        :setup_fee   => 10,
        :monthly_fee => 20 }
    end
    
    it 'should dump features' do
      plan.instance_eval do
        feature     :mo
        feature     :mt, :limit => 5, :unit_price => 2
      end
      
      res = plan.to_snapshot
      res.keys.should =~ [ :features, :setup_fee, :monthly_fee ]
      res[:features].keys.should =~ [ :mo, :mt ]
    end
  end

  describe 'from_snapshot' do
    let(:plan) do
      PerfectPrice::Plan.from_snapshot(
        :name        => 'name_val',
        :label       => 'label_val',
        :meta        => { :description => 'descr_val' },
        :setup_fee   => 10,
        :monthly_fee => 20,
        :features    => { :mo => { :limit => 5 } }
      )
    end
    
    specify { plan.name.should == 'name_val' }
    specify { plan.label.should == 'label_val' }
    specify { plan.meta.should == { :description => 'descr_val' } }
    specify { plan.setup_fee.should == 10 }
    specify { plan.monthly_fee.should == 20 }
    specify { plan.features.size.should == 1 }
    specify { plan.feature(:mo).limit.should == 5 }
  end
end