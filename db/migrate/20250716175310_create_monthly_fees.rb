class CreateMonthlyFees < ActiveRecord::Migration[7.2]
  def change
    create_table :monthly_fees do |t|
      t.references :merchant, null: false, foreign_key: true
      t.string :month, null: false
      t.decimal :total_fees, precision: 10, scale: 2, null: false
      t.decimal :charged_fee, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :monthly_fees, [:merchant_id, :month], unique: true
  end
end
