class AddCreatedByToListItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :list_items, :created_by, index: true, foreign_key: { to_table: :accounts }
  end
end
