class AddAccountGroupIdToAccount < ActiveRecord::Migration[8.0]
  def change
    add_reference :accounts, :account_group, index: true
  end
end
