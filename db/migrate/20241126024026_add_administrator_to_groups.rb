class AddAdministratorToGroups < ActiveRecord::Migration[8.0]
  def change
    add_reference :groups, :administrator, index: true, foreign_key: { to_table: :accounts }
  end
end
