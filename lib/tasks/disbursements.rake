namespace :disbursements do
  desc 'Process disbursements for current date'
  task process: :environment do |task, args|
    date = Date.current

    service = DisbursementService.new(date)

    # separated the logic into smaller services in pro of reusability and testability
    service.process_disbursements
  end
end
