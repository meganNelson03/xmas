class RenameAccountGroups < ActiveRecord::Migration[8.0]
  def change
    rename_table :account_groups, :groups
    rename_column :accounts, :account_group_id, :group_id
  end
end
