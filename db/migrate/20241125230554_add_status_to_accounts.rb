class AddStatusToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :status, :string
  end
end
