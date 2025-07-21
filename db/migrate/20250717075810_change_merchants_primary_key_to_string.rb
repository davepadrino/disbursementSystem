class ChangeMerchantsPrimaryKeyToString < ActiveRecord::Migration[7.2]
  def up
    remove_foreign_key :disbursements, :merchants
    remove_foreign_key :orders, :merchants
    remove_foreign_key :monthly_fees, :merchants

    change_column :disbursements, :merchant_id, :string
    change_column :orders, :merchant_id, :string
    change_column :monthly_fees, :merchant_id, :string
    # INFO: Add new string column for id (i forgot to add it in the original migration)
    add_column :merchants, :new_id, :string

    remove_column :merchants, :id
    rename_column :merchants, :new_id, :id

    execute "ALTER TABLE merchants ADD PRIMARY KEY (id);"

    add_foreign_key :disbursements, :merchants, column: :merchant_id, primary_key: :id
    add_foreign_key :orders, :merchants, column: :merchant_id, primary_key: :id
    add_foreign_key :monthly_fees, :merchants, column: :merchant_id, primary_key: :id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end