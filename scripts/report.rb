def create_report
  years = (2022..Date.current.year).to_a # INFO: automatically includes new years as they come

  years.map do |year|
    disbursement = Disbursement.where('YEAR(disbursement_date) = ?', year)
    monthly_fees = MonthlyFee.where('YEAR(month) = ?', year).where('charged_fee > 0')
    {
      year: year,
      number_of_disbursements: disbursement.count,
      amount_disbursed_to_merchants: disbursement.sum(:total_amount),
      amount_of_order_fees: disbursement.sum(:total_fees),
      number_of_monthly_fees: monthly_fees.count,
      amount_of_monthly_fees_charged: monthly_fees.sum(:charged_fee),
    }
  end
end


create_report.each do |report|
  puts "Year: #{report[:year]}"
  puts "Number of Disbursements: #{report[:number_of_disbursements]}"
  puts "Amount Disbursed to Merchants: #{report[:amount_disbursed_to_merchants]}"
  puts "Amount of Order Fees: #{report[:amount_of_order_fees]}"
  puts "Number of Monthly Fees: #{report[:number_of_monthly_fees]}"
  puts "Amount of Monthly Fees Charged: #{report[:amount_of_monthly_fees_charged]}"
  puts "-" * 40
end