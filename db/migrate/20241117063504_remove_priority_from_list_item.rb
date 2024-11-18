class RemovePriorityFromListItem < ActiveRecord::Migration[8.0]
  def change
    remove_column :list_items, :priority
  end
end
