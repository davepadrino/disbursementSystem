require 'csv'

require Rails.root.join('app/models/merchant')
require Rails.root.join('app/models/order')

def import_merchants
  p "Importing merchants..."
  CSV.foreach(Rails.root.join('merchants.csv'), headers: true, col_sep: ';') do |row|
     Merchant.find_or_create_by(id: row['id']) do |m|
      m.reference = row['reference']
      m.email = row['email']
      m.live_on = Date.parse(row['live_on'])
      m.disbursement_frequency = row['disbursement_frequency']
      m.minimum_monthly_fee = row['minimum_monthly_fee'].to_f
    end
    print "."
  end

  p "Sucessfully imported #{Merchant.count} merchants"
end

def import_orders
  p "Importing orders..."
  
  merchant_mapping = {}
  Merchant.find_each do |merchant|
    merchant_mapping[merchant.reference] = merchant.id
  end
 
  # defining a batch size for bulk insert
  # This helps to avoid memory issues with large datasets
  # and improves performance by reducing the number of database transactions.
  batch_size = 1000
  orders_batch = []
  
  CSV.foreach(Rails.root.join('orders.csv'), headers: true, col_sep: ';') do |row|
    merchant_id = merchant_mapping[row['merchant_reference']]
    next unless merchant_id
    
    orders_batch << {
      id: row['id'],
      merchant_id: merchant_id,
      amount: row['amount'].to_f,
       # better to calculate `commission_fee` in load time than having to read the whole orders later
       # also i've done this here to calculate the comission for the existing orders
       # since `insert_all` bypasses ActiveRecord callbacks and validations.
      commission_fee: CommissionCalculator.new(row['amount']).calculate,
      created_at: DateTime.parse(row['created_at']),
      updated_at: DateTime.current
    }
    
    if orders_batch.size >= batch_size
      Order.insert_all(orders_batch)
      orders_batch.clear
      print '.'
    end
  end
  
  Order.insert_all(orders_batch) if orders_batch.any?
  
  p "Imported #{Order.count} orders"
end
p "Starting data import..."

# import_merchants
import_orders
