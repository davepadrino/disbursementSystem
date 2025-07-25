namespace :disbursements do
  desc 'Process disbursements for current date'
  task process: :environment do |task, args|
    date = Date.current

    service = DisbursementService.new(date)
    p "Processing disbursements for #{@date}..."
    # INFO: separated the logic into smaller services in pro of reusability and testability
    service.process_disbursements
  end

  # INFO: this task takes AGES to process, I didn't find any better solution for the moment
  # taking into account that this one will run ONCE and then we'll rely on the daily task above
  # this of course needs to be improved via batching or parallel processing
  desc 'Process all historical disbursements'
  task process_all: :environment do |task, args|
    start_date = Merchant.minimum(:live_on)
    end_date = Date.current
    current_date = start_date

    p "Processing disbursements from #{start_date} to #{end_date}..."
    while current_date <= end_date
      service = DisbursementService.new(current_date)
      service.process_disbursements
      print "."
      current_date += 1.day
    end
    p "Finished processing disbursements up to #{end_date}."  
  end
end
