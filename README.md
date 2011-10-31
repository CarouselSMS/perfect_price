Perfect Price
=============

* Define your plans and features

* Use the definition to:
  * calculate the total for your billing
  * get data for the plans section of your page


Features
--------

* Plan definitions with:
  * Name
  * Setup and monthly fees
  * Features

* Feature definitions with:
  * Custom labels for rendering
  * Limits and units
  * Metered pricing (base price per unit, volume discounts)
  * Credits handling


What it's not
-------------

* It doesn't handle your charging
* It doesn't update your models


Defining a plan
---------------

Plans are defined in `config/initializers/perfect_price.rb` like this:

    PerfectPrice.configure do |c|

      c.feature :projects,  :label => "Projects", :limit => 35
      c.feature :storage,   :label => "Storage",  :limit => 15, :units => "Gb"
      c.feature :users,     :label => "Users",    :limit => PerfectPrice::UNLIMITED
      c.feature :mo
      c.feature :mt,        :base_price       => 0.05,
                            :bundled          => 100
                            :volume_discounts => {
                                20000   => 0.005,
                                50000   => 0.01,
                                100000  => 0.015,
                                250000  => 0.02,
                                500000  => 0.025,
                                1000000 => 0.03 }
    
      c.plan :max, :label => 'Max' do |p|
        p.setup_fee    100
        p.monthly_fee  149
        p.custom       { :label => "Top-of-the-line" }
        p.limits       :projects  => PerfectPrice::UNLIMITED,
                       :storage   => 75,
                       :notes     => PerfectPrice::UNLIMITED
      end
    
      c.plan :premium, :label => 'Premium' do |p|
        p.setup_fee    100
        p.monthly_feee 99
        p.custom       { :label => "The Sweet Spot" }
        p.limits       :projects  => 100,
                       :storage   => 30
      end
    
      c.plan :plus, :label => 'Plus' do |p|
        p.setup_fee    100
        p.monthly_fee  49
        p.custom       { :label => "For Small Groups" }
      end

    end


Calculating the total
---------------------

Assuming that you have an `Account` model that's responsible for all account handling logic, you might want to have the `process_payment` call like this:

    def Account.process_payment(payment)
        # Try charging with the total and return false if it didn't work
        return false unless self.subscription.charge(payment[:total])

        # Update credits
        self.credits = payment[:credits]
        save

        # Record the payment in log
        subscription_payments.create(:total => payment[:total], :details => payment[:details])
        return true
    end

And here's how you use the library to calculate the total amount for initial payment:

    # Initial payment
    plan    = account.plan
    payment = PerfectPrice.initial_payment(plan)

    unless account.process_payment(payment)
        # Notification
    end

When the time comes to calculate the monthly payment you do it like this:

    # Then monthly
    payment = PerfectPrice.monthly_payment(plan,
        :credits => { :feature_a => 100 },
        :usage   => { :feature_a => 150, :feature_b => 1 })

    unless account.process_payment(payment)
        # Notification
    end

In both cases the `payment` structure being returned contains the following:

    payment[:total]      # X + Y
    payment[:details]    # { 'monthy_fee' => X, 'feature_a' => Y }

When handling monthly payments, there also will be the updated `credits` section:

    payment[:credits]    # { :feature_a => 0 }

It's the intention that you get the details of the calculation in the `details` section for your records. This way you can explain how'd you come up with the number.

The `credits` section contains the updated credits hash that you can put back into your `account` upon the successful transaction.
