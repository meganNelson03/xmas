class AddPriorityBackToListItems < ActiveRecord::Migration[8.0]
  def change
    add_column :list_items, :priority, :integer, default: 0
  end
end
