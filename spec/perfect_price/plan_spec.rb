require 'perfect_price'

describe PerfectPrice::Plan do
  
  describe 'defaults' do
    its(:setup_fee)   { should == 0 }
    its(:monthly_fee) { should == 0 }
  end
  
  describe 'to_json' do
    let(:plan) { PerfectPrice::Plan.new }

    specify { plan.to_json.should == { :setup_fee => 0, :monthly_fee => 0 }.to_json }
    
    it 'should dump basic options' do
      plan.instance_eval do
        name        "name_val"
        label       "label_val"
        meta        :a => 1, :b => 2
        setup_fee   10
        monthly_fee 20
      end
      
      plan.to_json.should == {
        :name        => 'name_val',
        :label       => 'label_val',
        :meta        => { :a => 1, :b => 2 },
        :setup_fee   => 10,
        :monthly_fee => 20 }.to_json
    end
    
    it 'should dump features' do
      plan.instance_eval do
        feature     :mo
        feature     :mt, :limit => 5, :unit_price => 2
      end
      
      res = JSON.parse(plan.to_json)
      res.keys.should =~ %w{ features setup_fee monthly_fee }
      res['features'].keys.should =~ %w{ mo mt }
    end
  end

end