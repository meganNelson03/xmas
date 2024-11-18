class CreateListItems < ActiveRecord::Migration[8.0]
  def change
    create_table :list_items do |t|
      t.string :description, null: false
      t.string :url
      t.integer :priority
      t.float :price
      t.references :claimed_by, index: true, foreign_key: { to_table: :accounts }
      t.references :list, null: false
      t.timestamps
    end
  end
end
