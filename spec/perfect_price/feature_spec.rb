require 'perfect_price'

describe PerfectPrice::Feature do
       
  let(:feature) { PerfectPrice::Feature.new }

  describe 'volume_discount_for' do
    before  { feature.volume_discounts 1000 => 1, 2000 => 2 }
    specify { feature.volume_discount_for(-1).should   == 0 }
    specify { feature.volume_discount_for(0).should    == 0 }
    specify { feature.volume_discount_for(999).should  == 0 }
    specify { feature.volume_discount_for(1000).should == 1 }
    specify { feature.volume_discount_for(2000).should == 2 }
  end

  describe 'to_snapshot' do
    specify { feature.to_snapshot.should == {} }
    
    it 'should dump options' do
      feature.instance_eval do
        name              :mo
        limit             1000
        unit_price        0.05
        bundled           100
        volume_discounts  100 => 1, 200 => 2
      end
      
      feature.to_snapshot.should == {
        :name              => :mo,
        :limit             => 1000,
        :unit_price        => 0.05,
        :bundled           => 100,
        :volume_discounts  => { 100 => 1, 200 => 2 }
      }
    end
  end
  
  describe 'from_snapshot' do
    let(:feature) do
      PerfectPrice::Feature.from_snapshot(
        'name'              => 'mo',
        'limit'             => 1000,
        'unit_price'        => 0.05,
        'bundled'           => 100,
        'volume_discounts'  => { '100' => 1, '200' => 2 }
      )
    end
    
    specify { feature.name.should             == :mo }
    specify { feature.limit.should            == 1000 }
    specify { feature.unit_price.should       == 0.05 }
    specify { feature.volume_discounts.should == { 100 => 1, 200 => 2 } }
  end

end