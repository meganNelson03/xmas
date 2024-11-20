class CreateListItemsTags < ActiveRecord::Migration[8.0]
  def change
    create_table :list_items_tags do |t|
      t.references :list_item, null: false 
      t.references :tag, null: false
      t.timestamps
    end
  end
end
