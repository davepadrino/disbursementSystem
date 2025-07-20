class OrderService
  def initialize(merchant, date = Date.current)
    @merchant = merchant
    @date = date
  end

  def find_undisbursed_orders
    base_query = Order.where(merchant: @merchant, disbursement_id: nil)

    if @merchant.disbursement_frequency == 'DAILY'
      base_query.where(created_at: @date.beginning_of_day..@date.end_of_day)
    else
      last_date = @merchant.disbursements.maximum(:disbursement_date)
      start_date = last_date ? last_date + 1.day : @merchant.live_on
      base_query.where(created_at: start_date.beginning_of_day..@date.end_of_day)
    end
  end
end