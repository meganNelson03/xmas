class AddCurrentGroupIdToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_reference :accounts, :current_group, index: true, foreign_key: { to_table: :groups }
  end
end
