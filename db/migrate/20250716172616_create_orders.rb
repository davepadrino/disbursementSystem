class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :merchant, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.references :disbursement, foreign_key: true
      t.decimal :commission_fee, precision: 10, scale: 2

      t.timestamps
    end

    add_index :orders, :created_at
  end
end
