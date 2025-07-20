namespace :monthly_fees do
  desc 'Process monthly_fees to be run at the beginning of each month'
  task process: :environment do |task, args|
    service = MonthlyFeeService.new

    service.calculate_monthly_fees
  end
end
