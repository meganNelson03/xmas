class AddDefaultToPriority < ActiveRecord::Migration[8.0]
  def change
    change_column :list_items, :priority, :integer, default: 0
  end
end
