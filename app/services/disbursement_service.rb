class DisbursementService
   FREQUENCIES = {
    'DAILY' => :process_daily_merchants,
    'WEEKLY' => :process_weekly_merchants
  }.freeze

  def initialize(date = Date.current)
    @date = date
  end

  def process_disbursements
    # INFO: to aovid matrix-like structures
    FREQUENCIES.flat_map do |frequency, processor|
      merchants = find_merchants_by_frequency(frequency)
      send(processor, merchants)
    end
  end

  private

  def find_merchants_by_frequency(frequency)
    Merchant.where(disbursement_frequency: frequency)
           .where('live_on <= ?', @date)
  end

  def generate_reference(merchant, date)
    random_chars = SecureRandom.alphanumeric(2).upcase # to ensure uniqueness
    "#{merchant.reference}-#{date.strftime('%Y%m%d')}-#{random_chars}"
  end


  def create_disbursement(merchant, orders)
    total_amount = orders.sum(&:amount)
    commission_amount = orders.sum(&:commission_fee)

    Disbursement.create!(
        reference: generate_reference(merchant, @date),
        merchant: merchant,
        disbursement_date: @date,
        total_amount: total_amount,
        total_fees: commission_amount,
      )
  end

  # INFO: With null values in `disbursement_id`, we can know which orders haven't been disbursed yet.
  # This method updates the `Orders` table with the disbursement_id.
  def update_orders_with_disbursement(orders, disbursement)
    orders.update_all(disbursement_id: disbursement.id)
  end

  def process_merchant_disbursement(merchant)
    print "."
    orders = OrderService.new(merchant, @date).find_undisbursed_orders
    return nil if orders.empty?

    # INFO: I was not familiar with the `tap` method, i investigated and now i love it for this case! :D
    create_disbursement(merchant, orders).tap do |disbursement|
      update_orders_with_disbursement(orders, disbursement)
    end
  end


  def same_weekday?(date1, date2)
    date1.wday == date2.wday
  end

  def process_daily_merchants(merchants)
    merchants.map do |merchant|
      process_merchant_disbursement(merchant)
    end
  end

  def process_weekly_merchants(merchants)
    merchants.select { |merchant| same_weekday?(merchant.live_on, @date) }
            .map { |merchant| process_merchant_disbursement(merchant) }
  end
end
