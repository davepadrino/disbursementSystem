class MonthlyFeeService
  def initialize(month_date = Date.current.beginning_of_month)
    @month_date = month_date
    @previous_month = month_date - 1.month
  end

  def calculate_monthly_fees
    # decided to use find_each to avoid loading all merchants into memory at once (in case of large datasets)
    p "Calculating monthly fee for all merchants..."
    Merchant.find_each do |merchant|
      next if MonthlyFee.exists?(merchant: merchant, month: @previous_month)
      print "."
      calculate_merchant_monthly_fee(merchant)
    end
end

  private

  def calculate_merchant_monthly_fee(merchant)
    fees_earned = calculate_earned_fees(merchant)
    minimum_fee_required = merchant.minimum_monthly_fee
    monthly_fee_charged = monthly_fee_charged(fees_earned, minimum_fee_required)
    MonthlyFee.create!(
      merchant: merchant,
      month: @previous_month,
      total_fees: fees_earned,
      charged_fee: monthly_fee_charged,
    )
  end

  def calculate_earned_fees(merchant)
    disbursements = merchant.disbursements.where(
      disbursement_date: @previous_month.beginning_of_month..@previous_month.end_of_month
    )
    disbursements.sum(:total_fees)
  end

  def monthly_fee_charged(fees_earned, minimum_fee_required)
    return 0 if fees_earned >= minimum_fee_required # if merchant earned more than the minimum fee, no fee is charged
    minimum_fee_required - fees_earned
  end
end
