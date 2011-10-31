require 'perfect_price'

describe PerfectPrice::Feature do
       
  describe 'volume_discount_for' do
    before do
      @feature = PerfectPrice::Feature.new(:mt, :volume_discounts => { 1000 => 1, 2000 => 2 })
    end

    specify { @feature.volume_discount_for(-1).should   == 0 }
    specify { @feature.volume_discount_for(0).should    == 0 }
    specify { @feature.volume_discount_for(999).should  == 0 }
    specify { @feature.volume_discount_for(1000).should == 1 }
    specify { @feature.volume_discount_for(2000).should == 2 }
  end

end