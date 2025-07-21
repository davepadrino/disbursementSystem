class ChangeOrdersPrimaryKeyToString < ActiveRecord::Migration[7.2]
    def up
    # INFO: Add new string column for id (i forgot to add it in the original migration)
    add_column :orders, :new_id, :string

    remove_column :orders, :id
    rename_column :orders, :new_id, :id

    execute "ALTER TABLE orders ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
