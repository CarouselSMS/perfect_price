require 'perfect_price'

describe PerfectPrice, 'calculations' do
  
  SETUP_FEE            = 100
  MONTHLY_FEE          = 10
  UNIT_PRICE           = 5
  BUNDLED              = 10
  VOLUME_DISCOUNT_1000 = 1
  VOLUME_DISCOUNT_2000 = 2
  
  let(:plan) { PerfectPrice.plan(:easy) }

  before do
    PerfectPrice.configure do
      feature :mt,  :unit_price       => UNIT_PRICE,
                    :bundled          => BUNDLED,
                    :volume_discounts => { 1000 => VOLUME_DISCOUNT_1000, 2000 => VOLUME_DISCOUNT_2000 }

      plan :easy do |p|
        setup_fee   SETUP_FEE
        monthly_fee MONTHLY_FEE
      end
    end
  end
  
  describe 'initial' do
    let(:payment) { PerfectPrice.initial_payment(plan) }
    specify { payment.total.should    == SETUP_FEE }
    specify { payment.details.should  == { 'setup_fee' => SETUP_FEE } }
  end
  
  describe 'flat monthly' do
    let(:payment) { PerfectPrice.monthly_payment(plan) }
    specify { payment.total.should    == MONTHLY_FEE }
    specify { payment.details.should  == { 'monthly_fee' => MONTHLY_FEE } }
  end
  
  describe 'metered' do
    context 'feature usage is covered with bundle' do
      let(:payment) { PerfectPrice.monthly_payment(plan, :usage => { :mt => 9 }) }
      specify { payment.total.should    == MONTHLY_FEE }
      specify { payment.details.should  == { 'monthly_fee' => MONTHLY_FEE, 'mt_bundled_used' => 9 } }
    end
    
    context 'feature usage is over bundled' do
      let(:payment) { PerfectPrice.monthly_payment(plan, :usage => { :mt => 15 }) }
      specify { payment.total.should    == MONTHLY_FEE + UNIT_PRICE * (15 - BUNDLED) }
    end
    
    context 'with volume discount' do
      let(:payment) { PerfectPrice.monthly_payment(plan, :usage => { :mt => 1001 }) }
      specify { payment.total.should    == MONTHLY_FEE + (UNIT_PRICE - VOLUME_DISCOUNT_1000) * (1001 - BUNDLED) }
    end
    
    context 'with credits' do
      let(:payment) { PerfectPrice.monthly_payment(plan, :usage => { :mt => BUNDLED + 100 }, :credits => { :mt => 90 }) }
      specify { payment.total.should    == MONTHLY_FEE + UNIT_PRICE * 10 }
      specify { payment.details.should  == { 'monthly_fee' => MONTHLY_FEE, 'mt_fee' => 10 * UNIT_PRICE, 'mt_credits_used' => 90, 'mt_bundled_used' => BUNDLED } }
      specify { payment.credits.should  == { 'mt' => 0 } }
    end
  end
  
end