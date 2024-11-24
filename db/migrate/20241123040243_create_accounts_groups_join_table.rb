class CreateAccountsGroupsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :accounts, :groups
  end
end
