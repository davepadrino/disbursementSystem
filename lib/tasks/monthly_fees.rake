namespace :monthly_fees do
  desc 'Process monthly_fees to be run at the beginning of each month'
  task process: :environment do |task, args|
    service = MonthlyFeeService.new
    p "Calculating monthly fee for all merchants..."


    service.calculate_monthly_fees
  end

  desc "Process historical monthly_fees"
    task process_all: :environment do |task, args|
      start_date = Merchant.minimum(:live_on)
      end_date = Date.current
      # as months pass, we'll need to improve this method to process by batches or in parallel

      current_date = start_date

      p "Processing historical monthly from #{start_date} to #{end_date}..."
      while current_date <= end_date
        service = MonthlyFeeService.new(current_date.beginning_of_month)
        service.calculate_monthly_fees
        print "."
        current_date += 1.month
      end
      p "Finished processing historical monthly fees up to #{end_date}."

    end
end
