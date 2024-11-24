class AddAccountGroupIdToAccount < ActiveRecord::Migration[8.0]
  def change
    add_reference :accounts, :group, index: true
  end
end
